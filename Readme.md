# Google Multi-Translator

## Installation

```sh
gem install google-cloud-translate
```

You will need a [Google Cloud API account](https://cloud.google.com/translate/docs/quickstart-client-libraries#client-libraries-install-ruby).

### Required changes

- `PROJECT_ID` within `translate.rb` needs to be configured to your project id.
- You must set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the
path to the downloaded JSON configuration file.

## Usage

```ruby
load 'translate.rb'

t = Translate.new(steps: 10) do
  [
    'This is a test.',
    'These will be translated too much.',
    'You have been warned.'
  ]
end

t.run # Calls the API
t.text # The resultant text.
t.language_names # The names of the languages used.
```

You can also specify which languages to use:

```ruby
t = Translate.new(
  use_languages: [
    { 'name' => 'French', 'code' => 'fr' },
    { 'name' => 'German', 'code' => 'de' }
  ]
) do
  [
    'This is a test.',
    'These will be translated too much.',
    'You have been warned.'
  ]
end
```
