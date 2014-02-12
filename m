From: gianluca <gianlucarenzi-RMR/+jklkADqD7ZJT3/+rDUZDU+1vuVT@public.gmane.org>
Subject: Hello list!
Date: Wed, 12 Feb 2014 11:16:10 +0100
Message-ID: <52FB49EA.30004@eurekelettronica.it>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello list!

I am working on a selfmade board with ARM9 and eMMC as storage.
The final product will be a logger (from solar-inverter, to bus-logger,=
=20
etc.,...) so I choose a rootfilesystem with NILFS2.
The distro is a deboostrap based for ARMEL Debian Wheezy 7.2.

I changed the critical filesystem folders (/var, /var/log, /tmp...) to=20
be tempfs in ram for obviously reasons and the rootfilesystem is nilfs2=
=20
based with a noatime option activated.

The protection period is set at 60 seconds because the application can=20
write data even in shorter periods, but 60 seconds it is a average valu=
e=20
to have a disk-full problem away from normal-user.

What about the wear-leveling of this configuration of the eMMC device?

Can you point me on some tools, utilities to check out this issue?

Best regards,
--=20
            ,,,
           (o o)
=3D=3D=3D=3D=3D=3DoOO=3D=3D(_)=3D=3DOOo=3D=3D=3D=3D=3D=3D

Gianluca Renzi
R&D
phone: +39.0542.609120
fax:   +39.0542.609212

       .oooO  Oooo.
=3D=3D=3D=3D=3D=3D(   )=3D=3D(   )=3D=3D=3D=3D=3D=3D=3D
        \ (    ) /
         \_)  (_/

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
  \ source code!  /
   ---------------
     =C2=AF\_(".)_/=C2=AF
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
