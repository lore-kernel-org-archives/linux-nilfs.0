From: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] fs/nilfs2: Fix potential underflow in call to crc32_le
Date: Mon, 20 Jun 2016 06:41:44 +0200
Message-ID: <57677408.1@secunet.com>
References: <5763AF95.7050302@secunet.com>
 <20160618.032507.1597365191396955107.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------080500070002060107020503"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160618.032507.1597365191396955107.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

--------------080500070002060107020503
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit

On 17.06.2016 20:25, Ryusuke Konishi wrote:
> Hi,
> 
> I have a few comments.  Please see the inline comments below.
> 
> On Fri, 17 Jun 2016 10:06:45 +0200, Torsten Hilbrich wrote:
>> The value bytes comes from the filesystem which is about to be
>> mounted. We cannot trust that the value is always in the range
>> we expect it to be.
>>
>> Check its value before using it to calculate the length for the
>> crc32_le call. It value must be larger (or equal) sumoff + 4 and
>> smaller than the remaining space in the block where the superblock
>> is stored (BLOCK_SIZE - sumoff - 4).
>>
> 
>> This fixes a problem where the accidential mounting of an encrypted
>> volume caused a kernel panic. It had the correct magic value 0x3434
>> at offset 0x406 by chance and the following 2 bytes were 0x01, 0x00
>> (interpreted as s_bytes value with value 1).
> 
> Could you improve the description on the problem a bit ?
> 
> The true issue looks a "memory access overrun" on the superblock
> buffer that can occur when "s_bytes - sumoff - 4" underflows and
> crc32_le() receives an uninteded large byte count.
>
> The reason why a "kernel panic" occurs, is unclear in the comment.
>
> Even if a non-nilfs volume is mistakenly mounted as a nilfs volume, it
> usually will return an error.  Kernel panic should never occur just by
> an accidental mount.  If it happens except the overrun issue, it is
> another bug.

You are right, I only got the kernel panic when first testing on a
grsecurity kernel. I repeated the test and there just a BUG on the
underflow/overrun is reported. I have attached the kernel logs of this
test run to this mail (nilfs.bug).

> 
>>
>> Signed-off-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
>> Tested-by: Torsten Hilbrich <torsten.hilbrich-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  fs/nilfs2/the_nilfs.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
>> index 69bd801..21f6b23 100644
>> --- a/fs/nilfs2/the_nilfs.c
>> +++ b/fs/nilfs2/the_nilfs.c
>> @@ -438,18 +438,19 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
>>  	static unsigned char sum[4];
>>  	const int sumoff = offsetof(struct nilfs_super_block, s_sum);
>>  	size_t bytes;
>> +	size_t crc_offset = sumoff + 4;
> 
> The name "crc_offset" is confusing.  This just means the offset of the
> latter part of the region that the crc function will verify.
> In addition, it should be defined with a "const" qualifier.

I will rename it to crc_start.

> 
>>  	u32 crc;
>>  
>>  	if (!sbp || le16_to_cpu(sbp->s_magic) != NILFS_SUPER_MAGIC)
>>  		return 0;
>>  	bytes = le16_to_cpu(sbp->s_bytes);
>> -	if (bytes > BLOCK_SIZE)
> 
>> +	if (bytes < crc_offset || bytes > BLOCK_SIZE - crc_offset)
> 
> The latter part of this test should be "bytes > BLOCK_SIZE".
> Why do you subtract crc_offset here ?

I made here some wrong assumption about the memory layout and the
meaning of bytes. bytes is the end of the area which is to be
crc32-checked so comparing against BLOCK_SIZE (which should be the
maximum size of the super block) is okay.

> 
> Regards,
> Ryusuke Konishi
> 
>>  		return 0;
>>  	crc = crc32_le(le32_to_cpu(sbp->s_crc_seed), (unsigned char *)sbp,
>>  		       sumoff);
>>  	crc = crc32_le(crc, sum, 4);
>> -	crc = crc32_le(crc, (unsigned char *)sbp + sumoff + 4,
>> -		       bytes - sumoff - 4);
>> +	crc = crc32_le(crc, (unsigned char *)sbp + crc_offset,
>> +		       bytes - crc_offset);
>>  	return crc == le32_to_cpu(sbp->s_sum);
>>  }
>>  
>> -- 
>> 2.1.4
>> --

I will sent an updated patch.

	Torsten



--------------080500070002060107020503
Content-Type: text/plain; charset="UTF-8"; name="nilfs.bug"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="nilfs.bug"

[201699.185465] BUG: unable to handle kernel paging request at ffff88021e=
600000
[201699.186111] IP: [<ffffffff814083c6>] crc32_le+0x36/0x100
[201699.186724] PGD 21ff067 PUD 2202067 PMD 0=20
[201699.187333] Oops: 0000 [#1] SMP=20
[201699.187936] Modules linked in: nilfs2 ec_sys nls_iso8859_1 uas usb_st=
orage usbhid hid msr algif_skcipher af_alg ctr ccm bnep snd_hrtimer pci_s=
tub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) bluetooth vboxdrv(OE) binfm=
t_misc drbg ansi_cprng dm_crypt uvcvideo intel_rapl x86_pkg_temp_thermal =
intel_powerclamp videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 corete=
mp kvm_intel kvm videobuf2_core irqbypass v4l2_common crct10dif_pclmul cr=
c32_pclmul videodev media aesni_intel arc4 cdc_mbim aes_x86_64 lrw iwldvm=
 gf128mul glue_helper snd_hda_codec_hdmi ablk_helper mac80211 cdc_ncm cry=
ptd usbnet mii cdc_acm cdc_wdm snd_hda_codec_conexant snd_hda_codec_gener=
ic input_leds snd_hda_intel iwlwifi snd_hda_codec serio_raw snd_hda_core =
snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event thinkpad_acpi snd_rawmi=
di cfg80211
[201699.190960]  snd_seq nvram snd_seq_device shpchp snd_timer lpc_ich sn=
d mei_me mei soundcore mac_hid cuse parport_pc ppdev lp parport autofs4 i=
915 i2c_algo_bit drm_kms_helper psmouse ahci sdhci_pci syscopyarea sysfil=
lrect sysimgblt libahci fb_sys_fops sdhci drm e1000e ptp pps_core wmi fje=
s video
[201699.192637] CPU: 2 PID: 17038 Comm: mount Tainted: G           OE   4=
=2E4.0-24-generic #43-Ubuntu
[201699.193447] Hardware name: LENOVO 4236NGG/4236NGG, BIOS 83ET76WW (1.4=
6 ) 07/05/2013
[201699.194265] task: ffff8801ea069b80 ti: ffff8801216d8000 task.ti: ffff=
8801216d8000
[201699.195074] RIP: 0010:[<ffffffff814083c6>]  [<ffffffff814083c6>] crc3=
2_le+0x36/0x100
[201699.195886] RSP: 0018:ffff8801216dbc50  EFLAGS: 00010296
[201699.196698] RAX: 0000000000000000 RBX: 000000000000002b RCX: 00000000=
00000065
[201699.197499] RDX: ffffffffffffffe8 RSI: ffff88021e600000 RDI: 00000000=
dd21f2f1
[201699.198320] RBP: ffff8801216dbc58 R08: ffff8801527b33f8 R09: ffff8801=
527b3410
[201699.199101] R10: 0000000000000005 R11: 00000000000000b4 R12: 00000000=
00000001
[201699.199889] R13: 0000000000000400 R14: ffff8801216dbce8 R15: 00000000=
000ff000
[201699.200669] FS:  00007efc89607840(0000) GS:ffff88021e280000(0000) knl=
GS:0000000000000000
[201699.201456] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[201699.202253] CR2: ffff88021e600000 CR3: 000000019e010000 CR4: 00000000=
000406e0
[201699.203040] Stack:
[201699.203811]  ffff8801527b3400 ffff8801216dbc78 ffffffffc0907492 ffff8=
8020ff64c00
[201699.204608]  ffff8801bda5d800 ffff8801216dbcd8 ffffffffc09075e2 fffff=
fff812479fd
[201699.205393]  ffff880161944000 ffff8801527b3400 ffff8801bda5d800 00000=
00061c2cd82
[201699.206202] Call Trace:
[201699.206982]  [<ffffffffc0907492>] nilfs_valid_sb.part.5+0x52/0x60 [ni=
lfs2]
[201699.207773]  [<ffffffffc09075e2>] nilfs_load_super_block+0x142/0x300 =
[nilfs2]
[201699.208564]  [<ffffffff812479fd>] ? set_blocksize+0x9d/0xd0
[201699.209355]  [<ffffffffc0908020>] init_nilfs+0x60/0x390 [nilfs2]
[201699.210160]  [<ffffffffc08fc962>] nilfs_mount+0x302/0x520 [nilfs2]
[201699.210930]  [<ffffffff811b16a5>] ? pcpu_alloc+0x385/0x670
[201699.211685]  [<ffffffff81210c58>] mount_fs+0x38/0x160
[201699.212413]  [<ffffffff811b19c5>] ? __alloc_percpu+0x15/0x20
[201699.213151]  [<ffffffff8122cbe7>] vfs_kern_mount+0x67/0x110
[201699.213898]  [<ffffffff8122f3b9>] do_mount+0x269/0xe00
[201699.214671]  [<ffffffff8122d5a4>] ? mntput+0x24/0x40
[201699.215432]  [<ffffffff811ef064>] ? __kmalloc_track_caller+0x1b4/0x25=
0
[201699.216207]  [<ffffffff8120eaf0>] ? __fput+0x190/0x220
[201699.216987]  [<ffffffff811ac0e2>] ? memdup_user+0x42/0x70
[201699.217777]  [<ffffffff8123027f>] SyS_mount+0x9f/0x100
[201699.218595]  [<ffffffff81825bf2>] entry_SYSCALL_64_fastpath+0x16/0x71=

[201699.219405] Code: c0 00 00 00 49 89 d2 48 c1 ea 03 4c 8d 4e fc 41 83 =
e2 07 48 85 d2 74 7f 48 c1 e2 03 4c 8d 44 16 fc 4c 89 ce 8b 46 04 48 83 c=
6 08 <8b> 0e 31 f8 41 89 c3 0f b6 f8 0f b6 dc 41 c1 eb 18 8b 3c bd c0=20
[201699.221341] RIP  [<ffffffff814083c6>] crc32_le+0x36/0x100
[201699.222300]  RSP <ffff8801216dbc50>
[201699.223246] CR2: ffff88021e600000
[201699.224200] ---[ end trace 1f71bf04a65dd7e5 ]---

--------------080500070002060107020503--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
