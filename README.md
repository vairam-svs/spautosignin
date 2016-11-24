spautosignin
============

A fork from spautosignin.codeplex.com; compatible with SP 2013. Includes github/vairam-svs/IPNetwork library to compare IP address within a network range string based on CIDR
See readme.txt and ps1 scripts found in the source code for how to deploy and configure.

This version chooses the most specific rule that matches the IP. For example, 10.141.1.0/24 will be chosen over 10.0.0.0/8 for the IP 10.141.1.177.
You can use 0.0.0.0/0 to specify the authentication method to use if no other rules match.
