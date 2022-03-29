require 'timeout'
require 'rexml/document'
require_relative 'lib/question.rb'

current_path = File.dirname(__FILE__)
file_name = "#{__dir__}/data/questions.xml"

puts "Викторина v. 1.1"
puts "Отвечать надо на скорость!"

right_answers_counter = 0
total_points = 0

questions = Question.read_from_xml(file_name)

questions.each do |question|
  question.show
  
  begin
  Timeout.timeout(question.time_for_answer) do      
    question.ask
  end

  if question.correctly_answered?
    right_answers_counter += 1
    total_points += question.points
    puts "Верно!"
  else
    puts "Неверно!"
  end
  
  rescue Timeout::Error
    puts 'Упс! Время вышло.'
  end
end

puts "\nВы заработали #{total_points} баллов за #{right_answers_counter} правильных ответа/ов из #{questions.size} возможных."
