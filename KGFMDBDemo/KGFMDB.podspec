
Pod::Spec.new do |s|
  s.name         = "KGFMDB"
  s.version      = "1.3.1"
  s.summary      = "KGFMDB is a lightweight, object-oriented, database manipulation tool based on FMDB. "
  s.description  = "KGFMDB is a lightweight, object-oriented, database manipulation tool based on FMDB.This tool is a very friendly library that supports insert, replace, delete, update, query and other operations."
  s.homepage     = "https://github.com/motinle/KGFMDBDemo"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Tinle Mo" => "motinle@163.com" }
  s.source       = { :git => "https://github.com/motinle/KGFMDBDemo.git", :tag => s.version.to_s }
  s.source_files = 'KGFMDBDemo/KGFMDB/**/*.{h,m}'
  s.dependency     "FMDB"
  s.platform     = :ios,'7.0'
end
