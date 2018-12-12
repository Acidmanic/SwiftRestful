Pod::Spec.new do |s|
s.name             = 'SwiftRestful'
s.version          = '0.0.4'
s.summary          = 'This library provides a framework for interact with Restful or other http endpoints.'
s.swift_version    = '4.0'

s.description      = <<-DESC
Swift Restful project provides some useful http access classes and tools, which hopefuly would make api calls easier. it also introduces a way to complete object serialization from/to json strings mostly behind the scene. the goal is for user to be able to call apis with their DTOs and receive DTOs in response automatically.
DESC
s.homepage         =  'https://github.com/Acidmanic/SwiftRestful'
s.license          = { :type => 'GPL', :file => 'LICENSE' }
s.author           = { 'Acidmanic' => 'acidmanic.moayedi@gmail.com' }
s.source           = { :git => 'https://github.com/Acidmanic/SwiftRestful.git', :tag => s.version }
s.social_media_url = 'https://about.me/moayedi'

s.ios.deployment_target = '9.3'
s.osx.deployment_target = '10.12'
s.watchos.deployment_target = "3.2"
s.tvos.deployment_target = '10.2'

s.source_files = 'SwiftRestful/**/*'
s.dependency 'NamingConventions'

end