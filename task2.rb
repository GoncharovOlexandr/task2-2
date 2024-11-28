require 'thread'

def process_numbers(input_file, output_file)
  begin
    numbers = File.readlines(input_file).map(&:to_i)
    squares = numbers.map { |num| num**2 }

    File.open(output_file, 'w') do |file|
      squares.each { |square| file.puts(square) }
    end

    puts "Processed #{input_file} -> #{output_file}"
  rescue => e
    puts "Error processing #{input_file}: #{e.message}"
  end
end

def process_files_with_threads(directory_path, output_directory)
  unless Dir.exist?(directory_path)
    puts "Input directory #{directory_path} does not exist"
    return
  end

  Dir.mkdir(output_directory) unless Dir.exist?(output_directory)

  input_files = Dir.entries(directory_path).select { |f| File.file?(File.join(directory_path, f)) }

  if input_files.empty?
    puts "No files to process in #{directory_path}"
    return
  end

  puts "Found #{input_files.size} files. Starting processing..."

  threads = []

  input_files.each do |input_file|
    threads << Thread.new do
      input_file_path = File.join(directory_path, input_file)
      output_file_path = File.join(output_directory, "squares_#{input_file}")

      process_numbers(input_file_path, output_file_path)
    end
  end

  threads.each(&:join)

  puts "All files processed"
end

input_directory = "./input_files"
output_directory = "./output_files"

process_files_with_threads(input_directory, output_directory)
