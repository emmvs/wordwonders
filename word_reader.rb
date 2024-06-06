# frozen_string_literal: true

def aggregated_words(file_path, word_limit)
  texts = extract_texts(file_path, 'Marlene von Kujawa')
  words = extract_significant_words(texts)
  sorted_word_counts(words, word_limit)
end

def extract_texts(file_path, sender_name)
  File.readlines(file_path).map do |line|
    if line.include?(':') && line.include?(sender_name) && !line.include?('omitted')
      line.split(']').last.strip.split(':', 2).last.strip
    end
  end.compact.join(' ')
end

def extract_significant_words(texts)
  clean_words = texts.downcase.gsub(/[^a-zäöüß0-9\s]/i, '').split
  stop_words = load_stop_words
  clean_words.reject { |word| stop_words.include?(word) }
end

def sorted_word_counts(words, limit)
  words.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
       .sort_by { |_word, count| -count }.first(limit).to_h
end

def load_stop_words
  german = File.readlines('german_stopwords.txt').map(&:strip)
  english = File.readlines('english_stopwords.txt').map(&:strip)
  german + english
end

# Usage example:
result = aggregated_words('marlene_chat.txt', 100)
puts result

# if __FILE__ == $PROGRAM_NAME
#   file_path = ARGV[0] || 'marlene_chat.txt'
#   word_limit = ARGV[1] ? ARGV[1].to_i : 10
#   result = aggregated_words(file_path, word_limit)
#   puts result
# end
