#
# spec file for package yast2-network
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           yast2-network
Version:        3.1.78
Release:        0

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

Group:          System/YaST
License:        GPL-2.0
# should be required by devtools
BuildRequires:  perl-XML-Writer pkgconfig rpm
BuildRequires:  update-desktop-files
BuildRequires:  yast2-testsuite
BuildRequires:  yast2-devtools >= 3.1.15
BuildRequires:  yast2-country
BuildRequires:  yast2-installation >= 2.15.27

# yast2 v3.1.86: Added ServicesProposal library
BuildRequires:  yast2 >= 3.1.86
# yast2 v3.1.97: Fixed checking whether SuSEfirewall2 package is installed/selected
Requires:       yast2 >= 3.1.97

#netconfig (FaTE #303618)
Requires:       sysconfig >= 0.80.0
#GetLanguageCountry
#(in newly created yast2-country-data)
Requires:       yast2-country-data >= 2.16.3
# Storage::IsDeviceOnNetwork
BuildRequires:  yast2-storage >= 2.21.11
Requires:       yast2-storage >= 2.21.11

# testsuite
BuildRequires:       rubygem-rspec

PreReq:         /bin/rm

# carrier detection
Conflicts:      yast2-core < 2.10.6

Requires:       yast2-ruby-bindings >= 1.0.0

Summary:        YaST2 - Network Configuration

%package devel-doc
Group:          System/YaST
Summary:        YaST2 - Developer documentation for yast2-network

%description 
This package contains the YaST2 component for network configuration.

%description devel-doc
This package contains autogenerated documentation for yast2-network

%prep
%setup -n %{name}-%{version}

%build
%yast_build

%install
%yast_install

%ifarch s390 s390x
/bin/rm -f $RPM_BUILD_ROOT/%{yast_desktopdir}/dsl.desktop
/bin/rm -f $RPM_BUILD_ROOT/%{yast_desktopdir}/isdn.desktop
/bin/rm -f $RPM_BUILD_ROOT/%{yast_desktopdir}/modem.desktop
%endif
/bin/rm -f $RPM_BUILD_ROOT/%{yast_desktopdir}/network.desktop
/bin/rm -f $RPM_BUILD_ROOT/%{yast_desktopdir}/provider.desktop


%post -p /bin/bash
# This fixes the files that were touched when #24842 was in effect.
# #42990: shut up when no wlan files are there.
shopt -s nullglob
files=`echo /etc/sysconfig/network/ifcfg-wlan*`
if [ -n "$files" ]; then
    /bin/chown root:root $files
    /bin/chmod 0600 $files
fi

%files
%defattr(-,root,root)
%{yast_ybindir}/*
%{yast_yncludedir}/network
%{yast_clientdir}/*.rb
%{yast_moduledir}/YaPI/NETWORK.pm
%{yast_moduledir}/*.rb
%{yast_desktopdir}/*.desktop
%{yast_scrconfdir}/*.scr
%{yast_agentdir}/ag_udev_persistent
%{yast_schemadir}/autoyast/rnc/networking.rnc
%{yast_schemadir}/autoyast/rnc/host.rnc
%dir %{yast_libdir}/network
%{yast_libdir}/network

%dir %{yast_docdir}
%{yast_docdir}/COPYING

%files devel-doc
%defattr(-,root,root)
%doc %{yast_docdir}
%exclude %{yast_docdir}/COPYING
%exclude %{yast_docdir}/README

%changelog
