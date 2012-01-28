From: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Subject: Re: Odd problem starting nilfs_cleanerd due to an eMMC misbehaviour
Date: Sat, 28 Jan 2012 13:53:00 +0100
Message-ID: <201201281353.00537.Martin@lichtvoll.de>
References: <20120126135203.GM2267@home.lan> (sfid-20120126_174957_944936_DD60FB44)
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120126135203.GM2267-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Am Donnerstag, 26. Januar 2012 schrieben Sie:
> Hi,
>=20
> I'm using nilfs2 for the root filesystem on an ARM-based netbook
> (Toshiba ac100) with Debian hardfloat. Custom kernel is based on 3.0.=
8
> and nilfs-tools is 2.1.0-1 from the Debian repository.
>=20
> I wanted to try the threaded i/o test from the Phoronix test suite an=
d
> somehow it happened that during the test the garbage collecting daemo=
n
> failed and never came back. So i got the filesystem 100% full and
> after i noticed it i tried running the daemon manually. It didn't
> start even after reboot. Suprisingly, the eMMC error went away on its
> own after fully powering off the whole device, and after that the
> daemon started to work properly.
>=20
> I'm not sure what conclusion might be made from this but i'd still
> appreciate any comments, especially the suggestions on what to do if
> the error didn't "recover".
>=20
> The relevant dmesg excerpts (full might be available from
> http://paulfertser.info/files/failing_emmc.txt ):
>=20
> [    2.837036] mmc0: new high speed MMC card at address 0001
> [    2.847637] mmcblk0: mmc0:0001 MMC32G 29.8 GiB
> ...
> [ 5668.706475] mmcblk0: retrying using single block read
> [ 5671.580366] mmcblk0: error -110 transferring data, sector 15563278=
,
> nr 122, card status 0x200900 [ 5671.603701] end_request: I/O error,
> dev mmcblk0, sector 15563278 [ 5674.421016] mmcblk0: error -110
> transferring data, sector 15563279, nr 121, card status 0x200900 [
> 5674.445322] end_request: I/O error, dev mmcblk0, sector 15563279 [
> 5674.466988] NILFS: GC failed during preparation: cannot read source
> blocks: err=3D-5 ...

Well I think thats clear: Thats an I/O error when trying to access the =
MMC=20
flash. I think the cleaner shouldn=B4t hang on it, but aside from that =
I do=20
not see a NILFS issue here.

As to the exact nature of the MMC error I have no idea. Maybe searching=
=20
for parts of the dmesg message does help.

I have I/O errors sometimes with the internal card reader on my ThinkPa=
d=20
T520 with Kingston Ultimate SD cards which work perfectly well with an=20
external USB card reader. I reported these to bugzilla.kernel.org after=
 I=20
noticed that some similar sounding issue was reported there as well.

So I recommend checking whether this might be a known issue with the mm=
c=20
driver in the Linux kernel.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
