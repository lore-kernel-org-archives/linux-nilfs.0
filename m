From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: NILFS2: double uuid
Date: Mon, 08 Jun 2015 17:18:34 +0900
Message-ID: <55754FDA.10406@lab.ntt.co.jp>
References: <20150608064314.GA3172@fritha.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150608064314.GA3172@fritha.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Heinz Diehl <htd+ml@fritha.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

(CCed to linux-nilfs@vger.kernel.org)
Hi Heinz,

On 2015/06/08 15:43, Heinz Diehl wrote:
> Hi,
>
> a nilfs2 formatted disk fails to mount via fstab due to double uuid's=
=2E
> See lsblk output below. The logs indicate that the system attempts to
> mount /dev/sdb rather than /dev/sdb1, which of course fails. In
> addition, /dev/sdb should not have any uuid at all. Don't know why
> that happens.
>
> The phenomenon is easily reproducible: format a partition with nilfs2=
,
> register it with the proper uuid in fstab and reboot. Tried both with
> USB memory and real HDD.
>
> [root@keera ~]# lsblk -f
> NAME        FSTYPE LABEL UUID                                 MOUNTPO=
INT
> sdb                      ff17dda9-fcae-42e7-a438-9087de58902e
> `-sdb1      xfs          ff17dda9-fcae-42e7-a438-9087de58902e
>
> Thanks,
>   Heinz

On 2015/06/08 15:49, Heinz Diehl wrote:
 > On 08.06.2015, Heinz Diehl wrote:
 >
 >> [root@keera ~]# lsblk -f
 >> NAME        FSTYPE LABEL UUID                                 MOUNT=
POINT
 >> sdb                      ff17dda9-fcae-42e7-a438-9087de58902e
 >> `-sdb1      xfs          ff17dda9-fcae-42e7-a438-9087de58902e
 >
 > Copy error: replace xfs with nilfs2. Sorry!

I couldn't reproduce the issue (in a CentOS 7 environment).

Could you tell us the version information of distro,
lsblk, libblkid, nilfs-utils, and kernel you are using ?

The following is an example of mine:

$ lsblk -f
NAME   FSTYPE LABEL  UUID                                 MOUNTPOINT
sda
=E2=94=94=E2=94=80sda1 nilfs2        9dcd01c0-2bc8-41bf-a400-8ad8755aac=
6a
$ lsblk --version
lsblk from util-linux 2.23.2

$ lscp -V
lscp (nilfs-utils 2.2.3)

$ rpm -q libblkid util-linux
libblkid-2.23.2-22.el7_1.x86_64
util-linux-2.23.2-22.el7_1.x86_64

$ uname -r
4.1.0-rc7


Regards,
Ryusuke Konishi
