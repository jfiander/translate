# frozen_string_literal: true

# Google Translate multi-language translator.
#
# gem install google-cloud-translate
class Translate
  require 'google/cloud/translate'

  PROJECT_ID ||= 'multi-translator-1562255043170'
  TRANSLATOR ||= Google::Cloud::Translate.new(project: PROJECT_ID)
  LANGUAGES ||= YAML.safe_load(File.read('languages.yml'))

  attr_reader :texts, :from, :steps, :languages

  def initialize(*texts, from: 'en', steps: 1, use_languages: nil)
    @texts = block_given? ? yield : texts
    @from = from
    @use_languages = use_languages
    @steps = use_languages&.size || steps
    @languages = {}
  end

  def run
    @languages = {}

    @steps.times do |step|
      language = pick_language(step)
      print "#{language} "

      translate(language)
    end

    translate(@from)
    print("\n")

    @texts
  end

  def text
    @texts.join("\n")
  end

  def language_names
    @languages.values.map { |h| h['name'] }
  end

  private

  def pick_language(step)
    return random_language(step) if @use_languages.nil?

    add_language(@use_languages.shift, step)
  end

  def random_language(step)
    add_language(LANGUAGES.sample, step)
  end

  def add_language(lang, step)
    @languages[step] = lang
    lang['code']
  end

  def translate(to)
    @texts = @texts.map { |text| TRANSLATOR.translate(text, to: to).text }
  end
end
