#!/usr/bin/env ruby

require 'fileutils'
require 'xcodeproj'

def update_plist(plist_file_path)
  out_file = File.open('./temp.info.plist', 'w')

  skipNext = false
  File.open(plist_file_path, 'r') do |f|
    f.each_line do |line|
      if (line['UIMainStoryboardFile'] || skipNext)
        puts "\tRemoving line: #{line}"
        skipNext = !skipNext
      else
        out_file.write(line)
      end
    end
  end

  # copy new file over info.plist, deleting the temp
  FileUtils.mv(out_file, plist_file_path)
end

WINDOW_INIT_CODE =
'    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UIViewController alloc] init];
'

def update_app_delegate(app_delegate_path)
    out_file = File.open('./temp.appdelegate.m', 'w')

    doInsert = false
    File.open(app_delegate_path, 'r') do |f|
      f.each_line do |line|
        if(line["didFinishLaunchingWithOptions"])
          doInsert = true
        end
        
        out_file.write(line)
        if(doInsert)
          doInsert = false
          out_file.write(WINDOW_INIT_CODE)
        end
      end
    end

    FileUtils.mv(out_file, app_delegate_path)
end


USAGE = "usage: 'ruby bye_storyboards.rb <project name>'"

if ARGV.length != 1
  abort "[error] no project name provided\n\t#{USAGE}"
end

project_top_level = ARGV[0]
project_name = project_top_level.split('/').last
puts "Removing default storyboard from #{project_name}..."

#
# Step 1:
# Remove UIMainStoryboardFile from Info.plist
#

plist_path = "#{project_top_level}/#{project_name}/Info.plist"
puts "==> Cleaning plist file: #{plist_path}"

update_plist(plist_path)

#
# Step 2:
# Remove Main.storyboard from the project
#

project_path = "#{project_top_level}/#{project_name}.xcodeproj"
puts "==> Opening project file: #{project_path}"

project = Xcodeproj::Project.open(project_path)

# Assuming the app is the first target... *shrug*
build_phase = project.targets.first.resources_build_phase
build_phase.files.to_a.map do |file|
  if file.file_ref.name == "Main.storyboard"
    puts "\tRemoving #{file.file_ref.name} from project"
    file.remove_from_project
  end
end

project.save

#
# Step 3:
# Add window intiailization code to app delegate
#

app_delegate_path = "#{project_top_level}/#{project_name}/AppDelegate.m"
puts "==> Updating app delegate: #{app_delegate_path}"

update_app_delegate(app_delegate_path);

puts "\nDone!\n\n"
