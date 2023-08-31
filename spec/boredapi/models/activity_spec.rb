# frozen_string_literal: true

require 'sqlite3'
require './lib/boredapi/models/activity'
require 'rspec'

describe Boredapi::Models::Activity do
  before(:all) do
    described_class.class_eval do
      def self.connect_to_db
        return @db if defined?(@db)

        @db = SQLite3::Database.new('spec/test_db.sqlite3')

        @db.results_as_hash = true

        @db.execute 'CREATE TABLE IF NOT EXISTS
        activities
        (
          id INTEGER PRIMARY KEY,
          activity TEXT,
          type TEXT,
          participants INTEGER,
          price REAL,
          link TEXT,
          key TEXT,
          accessibility REAL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )'

        @db
      end
    end
  end

  after(:all) do
    File.delete('spec/test_db.sqlite3') if File.exist?('spec/test_db.sqlite3')
  end

  describe '.save' do
    it 'saves an activity to the database' do
      activity_data = {
        'activity' => 'Test Activity',
        'type' => 'test',
        'participants' => 2,
        'price' => 0.5,
        'link' => 'http://test.com',
        'key' => 'test_key',
        'accessibility' => 0.3
      }

      expect do
        described_class.save(activity_data)
      end.to change { described_class.last5.size }.by(1)
    end
  end

  describe '.last5' do
    it 'returns the last 5 activities from the database' do
      10.times do |i|
        described_class.save(
          'activity' => "Test Activity #{i}",
          'type' => 'test',
          'participants' => 2,
          'price' => 0.5,
          'link' => "http://test#{i}.com",
          'key' => "test_key_#{i}",
          'accessibility' => 0.3
        )
      end

      activities = described_class.last5

      expect(activities.size).to eq(5)
    end
  end
end
