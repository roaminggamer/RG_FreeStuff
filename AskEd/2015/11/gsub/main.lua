local bob = "[[hello]]"

print(bob)

bob = string.gsub( bob, "%[", "" )
bob = string.gsub( bob, "%]", "" )

print( bob )