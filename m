From: "Milos Jana" <milosdsax-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Can't mount nilfs - error searching super root.
Date: Wed, 14 Jan 2009 23:04:30 +0100
Message-ID: <3313c4ab0901141404h97995dgf58282876b0ffd42@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1582568921=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1582568921==
Content-Type: multipart/alternative; 
	boundary="----=_Part_1520_29700630.1231970670467"

------=_Part_1520_29700630.1231970670467
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
After 2 weeks of successful using of NILFS on my pendrive I encountered this
error:

milos@computer:~$ sudo mount /media/pendrive/
[sudo] password for user:
mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid
argument

First, I thought there was something wrong with /etc/fstab entry, which
looks like this:

/dev/sdb /media/pendrive nilfs2 noauto,user,rw 0 0

But it looked the same when drive was working fine, I also tried different
parameters but it did not help. The last two lines from dmesg output made me
even more worry:

[ 759.733075] usb 7-3: new high speed USB device using ehci_hcd and address
5
[ 763.362043] usb 7-3: configuration #1 chosen from 1 choice
[ 763.713991] usbcore: registered new interface driver libusual
[ 763.730554] Initializing USB Mass Storage driver...
[ 763.730704] scsi5 : SCSI emulation for USB Mass Storage devices
[ 763.732474] usbcore: registered new interface driver usb-storage
[ 763.732480] USB Mass Storage support registered.
[ 763.732647] usb-storage: device found at 5
[ 763.732649] usb-storage: waiting for device to settle before scanning
[ 768.732513] usb-storage: device scan complete
[ 768.733715] scsi 5:0:0:0: Direct-Access USB 2.0 Flash Disk 1100 PQ: 0
ANSI: 0 CCS
[ 768.747539] sd 5:0:0:0: [sdb] 62652416 512-byte hardware sectors (32078
MB)
[ 768.748544] sd 5:0:0:0: [sdb] Write Protect is off
[ 768.748552] sd 5:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 768.748557] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[ 768.752786] sd 5:0:0:0: [sdb] 62652416 512-byte hardware sectors (32078
MB)
[ 768.753780] sd 5:0:0:0: [sdb] Write Protect is off
[ 768.753787] sd 5:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 768.753792] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[ 768.753803] sdb: sdb1
[ 768.857613] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[ 768.857786] sd 5:0:0:0: Attached scsi generic sg2 type 0
[ 1130.248957] NILFS warning: Segment magic number invalid
[ 1130.248965] NILFS: error searching super root.

I'm using nilfs2-tools 2.0.3-1 on kernel 2.6.27-10, the error also occurs
after upgrade to nilfs2-utils and nilfs kernel module 2.0.6.

How can I recover this drive? I didn't create any checkpoints, afair the
only thing I have done was to create the new filesystem using mkfs.nilfs2
command.

------=_Part_1520_29700630.1231970670467
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br>After 2 weeks of successful using of NILFS on my pendrive I encountered this error:<br><br>milos@computer:~$ sudo mount /media/pendrive/<br>[sudo] password for user:&nbsp;<br>mount.nilfs2: Error while mounting /dev/sdb on /media/pendrive: Invalid argument<br>
<br>First, I thought there was something wrong with /etc/fstab entry, which looks like this:<br><br>/dev/sdb	/media/pendrive	nilfs2	noauto,user,rw	0	0<br><br>But it looked the same when drive was working fine, I also tried different parameters but it did not help. The last two lines from dmesg output made me even more worry:<br>
<br>[  759.733075] usb 7-3: new high speed USB device using ehci_hcd and address 5<br>[  763.362043] usb 7-3: configuration #1 chosen from 1 choice<br>[  763.713991] usbcore: registered new interface driver libusual<br>[  763.730554] Initializing USB Mass Storage driver...<br>
[  763.730704] scsi5 : SCSI emulation for USB Mass Storage devices<br>[  763.732474] usbcore: registered new interface driver usb-storage<br>[  763.732480] USB Mass Storage support registered.<br>[  763.732647] usb-storage: device found at 5<br>
[  763.732649] usb-storage: waiting for device to settle before scanning<br>[  768.732513] usb-storage: device scan complete<br>[  768.733715] scsi 5:0:0:0: Direct-Access     USB 2.0  Flash Disk       1100 PQ: 0 ANSI: 0 CCS<br>
[  768.747539] sd 5:0:0:0: [sdb] 62652416 512-byte hardware sectors (32078 MB)<br>[  768.748544] sd 5:0:0:0: [sdb] Write Protect is off<br>[  768.748552] sd 5:0:0:0: [sdb] Mode Sense: 43 00 00 00<br>[  768.748557] sd 5:0:0:0: [sdb] Assuming drive cache: write through<br>
[  768.752786] sd 5:0:0:0: [sdb] 62652416 512-byte hardware sectors (32078 MB)<br>[  768.753780] sd 5:0:0:0: [sdb] Write Protect is off<br>[  768.753787] sd 5:0:0:0: [sdb] Mode Sense: 43 00 00 00<br>[  768.753792] sd 5:0:0:0: [sdb] Assuming drive cache: write through<br>
[  768.753803]  sdb: sdb1<br>[  768.857613] sd 5:0:0:0: [sdb] Attached SCSI removable disk<br>[  768.857786] sd 5:0:0:0: Attached scsi generic sg2 type 0<br>[ 1130.248957] NILFS warning: Segment magic number invalid<br>[ 1130.248965] NILFS: error searching super root.<br>
<br>I&#39;m using nilfs2-tools 2.0.3-1 on kernel 2.6.27-10, the error also occurs after upgrade to nilfs2-utils and nilfs kernel module 2.0.6.<br><br>How can I recover this drive? I didn&#39;t create any checkpoints, afair the only thing I have done was to create the new filesystem using  mkfs.nilfs2 command.<br>
<br><br>

------=_Part_1520_29700630.1231970670467--

--===============1582568921==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1582568921==--
