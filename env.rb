$:.unshift File.dirname( __FILE__)

# real time stdout
$stdout.sync = true
# $stderr.sync = true

# ENV vars
if File.exists?(".env")
  Hash[File.read(".env").
    gsub("\n\n","\n").
    split("\n").
    compact.map{|v| v.split("=")}].
    each { |k,v| ENV[k] = v }
end