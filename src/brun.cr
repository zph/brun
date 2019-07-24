require "file_utils"

module Brun
  VERSION = "0.1.0"

  OUTPUT_SUBDIR = "brun"

  class Run
    def self.call(cmd, args, chdir)
      stdout = IO::Memory.new
      stderr = IO::Memory.new
      process = Process.run(cmd, args, output: stdout, error: stderr, chdir: chdir)
      [stdout.to_s, stderr.to_s, process]
    end
  end

  BUILDER = {
    ".cr" => ->(main : String, output : String, dir : String) {
      pp Run.call("crystal", ["build", main, "-o", output], chdir: dir)
    },
    ".go" => ->(main : String, output : String, dir : String) {
      pp Run.call("go", ["build", "-o", output], chdir: dir)
    }
  }

  VCS = {
    git: ->(dir : String){
      stdout = IO::Memory.new
      Process.run("git", ["rev-parse", "--show-toplevel"], output: stdout, chdir: dir)
      stdout.to_s.chomp
    }
  }

  def self.call(entry, args)
    main = File.expand_path entry
    file = File.basename(main)
    # Get root
    git_root = VCS[:git].call(File.dirname(main))
    output = main.gsub("/", "_")
    tmpdir = File.join([Dir.tempdir, OUTPUT_SUBDIR])

    bin_output = File.join(tmpdir, output)

    if !Dir.exists?(tmpdir)
      FileUtils.mkdir_p(tmpdir)
    end

    if File.exists?(bin_output)
      brun = File.try { |f| f.info(bin_output) }
    end

    extension = File.extname(file)
    latest_modified = Dir.glob(File.join([git_root, "**/*#{extension}"])).map { |f| File.info(f).modification_time }.sort.last
    mtime = brun.try { |b| b.modification_time }
    if mtime.nil? || latest_modified > mtime
      # Rebuild
      BUILDER[extension].call(main, bin_output, git_root)

      puts "rebuilt binary #{bin_output}"
    end

    # puts "exec: #{bin_output} #{args}"
    Process.exec(bin_output, args)
  end
end

cmd = ARGV.shift
args = ARGV
Brun.call(cmd, args)
