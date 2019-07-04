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

  def initialize(*texts, from: 'en', steps: 1)
    @texts = block_given? ? yield : texts
    @from = from
    @steps = steps
    @languages = {}
  end

  def run
    @languages = {}

    @steps.times do |step|
      language = random_language(step)
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

  def random_language(step)
    lang = LANGUAGES.sample
    @languages[step] = lang
    lang['code']
  end

  def translate(to)
    @texts = @texts.map { |text| TRANSLATOR.translate(text, to: to).text }
  end
end
