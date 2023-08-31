# frozen_string_literal: true

require 'sqlite3'

module Boredapi
  module Models
    class Activity
      def self.last5
        connect_to_db.execute 'SELECT * FROM activities
                               ORDER BY created_at DESC
                               LIMIT 5'
      end

      def self.save(obj)
        connect_to_db.execute 'INSERT INTO
        activities
        (
          activity,
          type,
          participants,
          price,
          link,
          key,
          accessibility
        )
        values (?, ?, ?, ?, ?, ?, ?)', [
          obj['activity'],
          obj['type'],
          obj['participants'],
          obj['price'],
          obj['link'],
          obj['key'],
          obj['accessibility']
        ]
      end

      def self.connect_to_db
        return @db if defined?(@db)

        @db = SQLite3::Database.new 'db/ranvity.sqlite3'

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
end
