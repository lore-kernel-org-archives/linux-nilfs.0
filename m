From: Viacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000000000000a8 in nilfs_segctor_do_construct
Date: Tue, 19 Nov 2019 09:04:43 +0300
Message-ID: <76887BD9-D6C4-4A89-8F55-4BEAF2828FD3@dubeyko.com>
References: <8736emquds.fsf@logand.com>
 <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7ewKZqvC8CUc66wtGLDOYVqisKvlFeFsNPqY9MuL96o=;
        b=hX/EbL39mD2k0nNW8UYhI4Qp9jJ1yLmC9oO1hzWuq9PMeGvVigLucnJyZ9RSHStVbT
         AWRdbmVZYwdpkeRLMwDjxluIuB4HpaHEinCGgSUyUZIzgYcsKOiFIhPQTwo9//nyPUSi
         n7FCEIbc9l19qw0e5Erzf6S38Z1kySwWjosEJDElzebl6K26qzp6f39EEP2Vi1FG3WZT
         2jkHpatJ1XhFI6MtYRi/cNNlBWTnJTKiPiq0495WfIa/QZDY6IyOCCnfu58KwRYjdZIz
         QcCPEWn4tuFgp12LNZ3ia+aVvPH0xDfj1pt22cUNYsq8GMXTv8jNFnsZClhrTS7lVmUx
         3sfg==
In-Reply-To: <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Tomas Hlavaty <tom@logand.com>, linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>



> On Nov 18, 2019, at 7:51 PM, Ryusuke Konishi =
<konishi.ryusuke@gmail.com> wrote:
>=20
> Hi,
>=20
>> It was likely caused by improper shutdown and following nilfs2 =
partition
>> corruption.  Now I can still read the data, but on the whole the
>> computer is not useable, because starting a process which uses the
>> corrupted file system simply crashes in kernel.
>=20
> Thank you for reporting the issue.
> Let me ask you a few questions:
>=20
> 1) Is the crash reproducible in the environment ?
> 2) Can you mount the corrupted(?) partition from a recent version of =
kernel ?
> 3) Does read-only mount option (-r) work to avoid the crash ?


I believe it could be important to know more details about the partition =
too:
(1) the partition size?
(2) the logical block size?
(3) the segment size?
(4) how the partition was created?
(5) the version of tools that created the partition?
(6) the amount of free space on the partition?

Thanks,
Viacheslav Dubeyko.


>=20
> Thanks,
> Ryusuke Konishi
>=20
> 2019=E5=B9=B411=E6=9C=8818=E6=97=A5(=E6=9C=88) 2:34 Tomas Hlavaty =
<tom@logand.com>:
>>=20
>> Hi Ryusuke,
>>=20
>> today I got this bug in kernel, which seems to be related to nilfs2.
>>=20
>> It was likely caused by improper shutdown and following nilfs2 =
partition
>> corruption.  Now I can still read the data, but on the whole the
>> computer is not useable, because starting a process which uses the
>> corrupted file system simply crashes in kernel.  I am actually not =
sure
>> if the filesystem is corrupted, as I don't know about any tool to =
check
>> that.  The relevant parts of dmesg log are bellow.
>>=20
>> Please let me know if you are the right contact or if you need more =
info
>> about the problem.
>>=20
>> Thank you,
>>=20
>> Tomas
>>=20
>> [    0.000000] Linux version 4.19.84 (nixbld@localhost) (gcc version =
8.3.0 (GCC)) #1-NixOS SMP Tue Nov 12 18:21:46 UTC 2019
>> [    0.000000] Command line: =
initrd=3D\efi\nixos\4s51zw36kd1qb0ymk0charxjg8x6k5k3-initrd-linux-4.19.84-=
initrd.efi =
systemConfig=3D/nix/store/gdbxhzysr929abrymjqala0b5bh2fqmv-nixos-system-us=
hi-19.09.1258.07e66484e67 =
init=3D/nix/store/gdbxhzysr929abrymjqala0b5bh2fqmv-nixos-system-ushi-19.09=
.1258.07e66484e67/init loglevel=3D4
>>=20
>>=20
>>=20
>> [   37.741106] systemd-journald[470]: Received client request to =
flush runtime journal.
>> [   37.749084] systemd-journald[470]: File =
/var/log/journal/55a4ea9159c14c0bb8767a43819c6927/system.journal =
corrupted or uncleanly shut down, renaming and replacing.
>> [   37.810819] audit: type=3D1130 audit(1573985039.617:3): pid=3D1 =
uid=3D0 auid=3D4294967295 ses=3D4294967295 subj=3D=3Dunconfined =
msg=3D'unit=3Dsystemd-udevd comm=3D"systemd" =
exe=3D"/nix/store/v8flm2h07zcfg5k5npz56m0ayj0qm1q8-systemd-243/lib/systemd=
/systemd" hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
>>=20
>> [   38.321561] NILFS version 2 loaded
>> [   38.323236] NILFS (dm-1): mounting unchecked fs
>>=20
>>=20
>> [   38.349185] NILFS (dm-1): recovery complete
>> [   38.353228] NILFS (dm-1): segctord starting. Construction interval =
=3D 5 seconds, CP frequency < 30 seconds
>>=20
>> [   63.543941] systemd-journald[470]: File
>> /var/log/journal/55a4ea9159c14c0bb8767a43819c6927/user-1000.journal
>> corrupted or uncleanly shut down, renaming and replacing.
>>=20
>> [12637.085548] BUG: unable to handle kernel NULL pointer dereference =
at 00000000000000a8
>> [12637.085558] PGD 0 P4D 0
>> [12637.085567] Oops: 0000 [#1] SMP PTI
>> [12637.085574] CPU: 0 PID: 657 Comm: segctord Not tainted 4.19.84 =
#1-NixOS
>> [12637.085577] Hardware name: ASUSTeK COMPUTER INC. VivoBook 15_ASUS =
Laptop X507MA_R507MA/X507MA, BIOS X507MA.301 09/14/2018
>> [12637.085589] RIP: 0010:percpu_counter_add_batch+0x4/0x60
>> [12637.085593] Code: 89 e6 89 c7 e8 dd 3b 28 00 3b 05 fb e0 b6 00 72 =
d8 4c 89 ee 48 89 ef e8 7a 63 2a 00 48 89 d8 5b 5d 41 5c 41 5d c3 41 54 =
55 53 <48> 8b 47 20 65 44 8b 20 49 63 ec 48 63 ca 48 01 f5 48 39 e9 7e =
0a
>> [12637.085597] RSP: 0018:ffff9d1b00a0bd20 EFLAGS: 00010006
>> [12637.085601] RAX: 0000000000000002 RBX: 0000000000000000 RCX: =
0000000000000018
>> [12637.085604] RDX: 0000000000000018 RSI: 0000000000000001 RDI: =
0000000000000088
>> [12637.085608] RBP: ffff8df67a2988d0 R08: 0000000000000000 R09: =
ffff8df66fe0cfe0
>> [12637.085611] R10: 0000000000000230 R11: 0000000000000000 R12: =
0000000000000000
>> [12637.085614] R13: ffff8df67a298758 R14: ffff8df67a2988c8 R15: =
ffffccd684229a80
>> [12637.085618] FS:  0000000000000000(0000) GS:ffff8df67ba00000(0000) =
knlGS:0000000000000000
>> [12637.085621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [12637.085624] CR2: 00000000000000a8 CR3: 000000011ac0a000 CR4: =
0000000000340ef0
>> [12637.085628] Call Trace:
>> [12637.085640]  __test_set_page_writeback+0x37c/0x3f0
>> [12637.085663]  nilfs_segctor_do_construct+0x184e/0x2040 [nilfs2]
>> [12637.085680]  nilfs_segctor_construct+0x1f5/0x2e0 [nilfs2]
>> [12637.085693]  nilfs_segctor_thread+0x129/0x370 [nilfs2]
>> [12637.085706]  ? nilfs_segctor_construct+0x2e0/0x2e0 [nilfs2]
>> [12637.085713]  kthread+0x112/0x130
>> [12637.085719]  ? kthread_bind+0x30/0x30
>> [12637.085728]  ret_from_fork+0x1f/0x40
>> [12637.085734] Modules linked in: ctr ccm af_packet msr 8021q =
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic =
hid_multitouch arc4 ath9k ath9k_common ath9k_hw ath mac80211 snd_soc_skl =
snd_soc_skl_ipc spi_pxa2xx_platform asus_nb_wmi snd_soc_sst_ipc =
snd_soc_sst_dsp asus_wmi 8250_dw i2c_designware_platform sparse_keymap =
i2c_designware_core wmi_bmof i915 snd_hda_ext_core nilfs2 =
snd_soc_acpi_intel_match snd_soc_acpi uvcvideo videobuf2_vmalloc =
nls_iso8859_1 videobuf2_memops videobuf2_v4l2 snd_soc_core nls_cp437 =
rtsx_usb_ms intel_telemetry_pltdrv vfat intel_punit_ipc =
intel_telemetry_core fat intel_pmc_ipc memstick videobuf2_common =
snd_compress kvmgt vfio_mdev mdev ath3k vfio_iommu_type1 vfio btusb =
ac97_bus snd_pcm_dmaengine btrtl x86_pkg_temp_thermal intel_powerclamp =
btbcm cec coretemp btintel
>> [12637.085819]  crct10dif_pclmul crc32_pclmul videodev snd_hda_intel =
bluetooth drm_kms_helper ghash_clmulni_intel deflate media efi_pstore =
intel_cstate pstore intel_rapl_perf cfg80211 snd_hda_codec joydev =
mousedev evdev wdat_wdt serio_raw mac_hid efivars drm snd_hda_core =
snd_hwdep ecdh_generic snd_pcm snd_timer mei_me idma64 virt_dma snd =
intel_gtt agpgart i2c_i801 i2c_algo_bit mei fb_sys_fops syscopyarea =
soundcore rfkill processor_thermal_device sysfillrect sysimgblt =
intel_lpss_pci intel_soc_dts_iosf thermal wmi intel_lpss i2c_hid =
i2c_core battery tpm_crb button ac tpm_tis tpm_tis_core asus_wireless =
video pcc_cpufreq tpm rng_core pinctrl_geminilake int3400_thermal =
int3403_thermal pinctrl_intel int340x_thermal_zone acpi_thermal_rel =
iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6
>> [12637.085912]  nf_defrag_ipv4 libcrc32c ip6t_rpfilter ipt_rpfilter =
ip6table_raw iptable_raw xt_pkttype nf_log_ipv6 nf_log_ipv4 =
nf_log_common xt_LOG xt_tcpudp ip6table_filter ip6_tables iptable_filter =
sch_fq_codel loop cpufreq_powersave tun tap macvlan bridge stp llc =
kvm_intel kvm irqbypass efivarfs ip_tables x_tables ipv6 crc_ccitt =
autofs4 ext4 crc32c_generic crc16 mbcache jbd2 fscrypto dm_crypt =
algif_skcipher af_alg rtsx_usb_sdmmc mmc_core rtsx_usb hid_generic =
usbhid hid sd_mod input_leds led_class atkbd libps2 ahci libahci =
xhci_pci libata xhci_hcd aesni_intel usbcore aes_x86_64 crypto_simd =
scsi_mod cryptd glue_helper crc32c_intel usb_common rtc_cmos i8042 serio =
dm_mod
>> [12637.086000] CR2: 00000000000000a8
>> [12637.086005] ---[ end trace ee0079180c990cd2 ]---
>> [12637.120805] RIP: 0010:percpu_counter_add_batch+0x4/0x60
>> [12637.120807] Code: 89 e6 89 c7 e8 dd 3b 28 00 3b 05 fb e0 b6 00 72 =
d8 4c 89 ee 48 89 ef e8 7a 63 2a 00 48 89 d8 5b 5d 41 5c 41 5d c3 41 54 =
55 53 <48> 8b 47 20 65 44 8b 20 49 63 ec 48 63 ca 48 01 f5 48 39 e9 7e =
0a
>> [12637.120809] RSP: 0018:ffff9d1b00a0bd20 EFLAGS: 00010006
>> [12637.120811] RAX: 0000000000000002 RBX: 0000000000000000 RCX: =
0000000000000018
>> [12637.120812] RDX: 0000000000000018 RSI: 0000000000000001 RDI: =
0000000000000088
>> [12637.120814] RBP: ffff8df67a2988d0 R08: 0000000000000000 R09: =
ffff8df66fe0cfe0
>> [12637.120815] R10: 0000000000000230 R11: 0000000000000000 R12: =
0000000000000000
>> [12637.120816] R13: ffff8df67a298758 R14: ffff8df67a2988c8 R15: =
ffffccd684229a80
>> [12637.120818] FS:  0000000000000000(0000) GS:ffff8df67ba00000(0000) =
knlGS:0000000000000000
>> [12637.120820] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [12637.120821] CR2: 00000000000000a8 CR3: 0000000138e0a000 CR4: =
0000000000340ef0

