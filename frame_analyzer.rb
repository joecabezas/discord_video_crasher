require 'json'
require 'pp'
require 'set'

def get_diffs(frames)
  values = {}
  keys = Set.new
  frames.each do |f|
    f.each do |k, v|
      value = values[k]
      keys.add(k) if !value.nil? && value != v
      values[k] = v
    end
  end
  frames.map do |f|
    f.slice(*keys)
  end
end

# you can get the frames json file of any video by doing:
# ffprobe -show_frames -print_format json output.mp4 > frames.json
frames = JSON.parse(File.read('frames.json'))['frames']

p "frames: #{frames.count}"

key_frames = frames.select { |f| f['key_frame'] == 1 }
p "key frames count: #{key_frames.count}"
pp get_diffs(key_frames)

yuv444p = frames.select { |f| f['pix_fmt'] == 'yuv444p' }
p "yuv444p frames count: #{yuv444p.count}"

yuv420p = frames.select { |f| f['pix_fmt'] == 'yuv420p' }
p "yuv420p frames count: #{yuv420p.count}"
# pp get_diffs(key_frames)
