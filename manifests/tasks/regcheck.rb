require 'win32/registry'

# Declare and initialize some local variables

@dotnetversion = []
versions = []
keyname = 'SOFTWARE\Microsoft\NET Framework Setup\NDP'
filterpattern = '^v'
subkeyval = 'Version'
clientkey = 'Client'
verbosemsg1 = '.NET versions have been found under: '

# KEY_ALL_ACCESS enables you to write and delete.
# the default access is KEY_READ if you specify nothing
access = Win32::Registry::KEY_READ

# regcheck function to sanity check the keyname to make sure it exists
# If not, exit gracefully with an error message

###################################
def regcheck(lockeyname, locaccess)
  unless Win32::Registry::HKEY_LOCAL_MACHINE.open(lockeyname, locaccess).nil?
    return Win32::Registry::HKEY_LOCAL_MACHINE.open(lockeyname, locaccess)
  end
rescue Win32::Registry::Error => e
  if e.code == 2
    puts 'Unable to find keyname: ' << lockkeyname.to_s << ' Are you sure it is correct?'
    exit
  end
end
###################################

# Call regcheck function to check whether the specific key exists

regcheck(keyname, access)

# List out sub-keys found

Win32::Registry::HKEY_LOCAL_MACHINE.open(keyname, access) do |reg|
  # each is the same as each_value, because #each_key actually means
  # "each child folder" so #each doesn't list any child folders...
  # use #keys for that...
  reg.each_key { |name, _value| versions.push(name) }
end

versions.each_with_index do |num, i|
  print '('
  print  i + 1
  print  ')'
  print "'"
  print num
  puts  "'"
end

filteredversions = versions.grep(%r{#{filterpattern}})
puts 'Sanitizing list based on filterpattern: ' << filterpattern.to_s
print filteredversions.size
puts ' ' << verbosemsg1.to_s << keyname.to_s

filteredversions.each_with_index do |num, i|
  print '('
  print i + 1
  print ') '
  tempkeyname = keyname
  tempkeyname += '\\'
  tempkeyname += num
  tempkeyname += "\\#{clientkey}"
  puts 'Getting .NET Version info for ' << tempkeyname.to_s << '\\' << subkeyval.to_s
  Win32::Registry::HKEY_LOCAL_MACHINE.open(tempkeyname, access) do |reg|
    @dotnetversion = reg[subkeyval.to_s, Win32::Registry::REG_SZ]
    puts "version='" << @dotnetversion << "'"
  end
end
