class tomcat::install ($packages, $tomcat, $version, $tomcat_archive, $java, $java_archive) {
package { "$packages":
 ensure => installed,
}
file {
 ["$tomcat","${tomcat}/tomcat-${version}"]:
   ensure => directory;
 ["${tomcat}/tomcat-${version}/conf/server.xml"]:
   ensure => file,
   content => template("tomcat/server.xml.erb"),
   require => Exec["tomcat-extract"];
  ["${tomcat}/tomcat-${version}/webapps/Calendar.war"]:
  ensure => file,
   source => "puppet:///modules/tomcat/Calendar.war",
   require => Exec["tomcat-extract"];
}
exec {
 "tomcat-archive" :
  cwd => "${tomcat}/tomcat-${version}",
  command => "wget ${tomcat_archive}",
  path => "/usr/bin",
  timeout => "3600",
  creates => "${tomcat}/tomcat-${version}/apache-tomcat-${version}.tar.gz";
 "tomcat-extract" :
  cwd => "${tomcat}/tomcat-${version}",
  command => "tar xvzf ${tomcat}/tomcat-${version}/apache-tomcat-${version}.tar.gz --strip 1 -C ${tomcat}/tomcat-${version}",
  path => "/bin",
  creates => "${tomcat}/tomcat-${version}/RELEASE-NOTES",
  require => Exec["tomcat-archive"];
 "start_tomcat":
  command => "sh ${tomcat}/tomcat-${version}/bin/startup.sh",
  path => "/bin", 
  user => "root",
}
}
