# This migration comes from idioma (originally 20140709015052)
class CreateIdiomaPhrases < ActiveRecord::Migration
  def change
    create_table :idioma_phrases do |t|
      t.string :locale
      t.string :i18n_key
      t.text :i18n_value
      t.datetime :translated_at
      t.datetime :flagged_at
      t.text :notes

      t.timestamps
    end
  end
end
