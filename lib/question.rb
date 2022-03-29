class Question
  attr_reader :points, :time_for_answer

  def initialize(text, variants, right_answer, time_for_answer, points)
    @text = text
    @answer_variants = variants
    @right_answer_index = right_answer
    @time_for_answer = time_for_answer
    @points = points
  end

  def self.read_from_xml(file_name)
    file = File.new(file_name, 'r:utf-8')
    
    doc = REXML::Document.new(file)
    file.close
    
    questions = []

    doc.elements.each('questions/question') do |questions_element|
      time_for_answer = questions_element.attributes['seconds'].to_i
      points = questions_element.attributes['points'].to_i

      text = ''
      variants = []
      right_answer = 0

      questions_element.elements.each do |question_element|
        case question_element.name
        when 'text'
          text = question_element.text
        when 'variants'
          question_element.elements.each_with_index do |variant, index|
            variants << variant.text
            
            right_answer = index if variant.attributes['right']  
            right_answer_value = variants[right_answer]
            variants.shuffle!
            
            right_answer = variants.index(right_answer_value)
          end
        end
      end

      questions << Question.new(text, variants, right_answer, time_for_answer, points)
    end

    return questions
  end

  def ask
    @answer_variants.each_with_index do |variant, index|
      puts "#{index + 1}. #{variant}"
    end
    puts "#{@points} баллов за правильный ответ."
    puts
    puts "Время на ответ: #{@time_for_answer} секунд."
    
    user_index = STDIN.gets.chomp.to_i - 1
    @correct = (@right_answer_index == user_index)
  end

  def show
    puts
    puts @text
  end

  def correctly_answered?
    @correct
  end
end
