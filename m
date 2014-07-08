From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Tue, 08 Jul 2014 07:08:19 +0530
Message-ID: <53BB4B8B.4060902@gmail.com>
References: <53ABA8F3.3010606@gmail.com>	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>	 <53ACF691.5090203@gmail.com> <1403850646.2588.4.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=e4H6gma4/JKdp1p3DXVp00iftPVBmn+RZgKGQZpFZK4=;
        b=HOwPh9q5RpwRMG/9+Xff1JDDcqJUkJSJ3EDzkvzhrmdpEIq28yecmot8BVGVQ48VOD
         BuRA0jdGoPW8xjAcnPQFKXM73fMHtsJ9j2Odm264UMkgolzxqHhA7j3MjfxpMolN9y5H
         6yA2sSwnYaUHHOHe3AJx5RDYtYQvpIUomzNeYcxa9bTYyly853mY1C1d6C1ypPGGkia/
         TsFDhVC6t2W1M70A3uOZzUDv/jGRmA0DEyOuxFkLrd0BTBSP2pUmzdfZgsMdmqXeOiKX
         h+MYDN3Hiy8H+gvyf/XDoQ2mLFabkwjHqP+eS8xZZ7/PEh5JaDb7HTN+NXMX4kJePKl1
         rYYQ==
In-Reply-To: <1403850646.2588.4.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/27/14 12:00, Vyacheslav Dubeyko wrote:
> On Fri, 2014-06-27 at 10:14 +0530, dE wrote:
>
> [snip]
>> I can confirm that at 4K block size, this issue never existed. It
>> started happening when I reduced the block size to improve write and
>> read seek performance when very small amounts of data was being
>> read/written.
>>
>> Yes, the FS was made at the specified day, but it was running
>> continuously since then.
>>
>> This problem triggers after running the programs for long amounts of
>> time. Like 1 day+ with GC running the background at low priority (idle
>> i/o). nilfs_cleanerd.conf --
>>
>> clean_check_interval    300
>> nsegments_per_clean     1
>> mc_nsegments_per_clean  1
>> cleaning_interval      0
>> mc_cleaning_interval   0
>> protection_period       0
>> min_clean_segments      100%
>> max_clean_segments      100%
>> selection_policy        timestamp       # timestamp in ascend order
>> retry_interval          300
>> use_mmap
>> log_priority            warning
>>
>> As of the nature of the program which's using files on the FS, it reads
>> and writes very small amounts of data from random places on a set of
>> files (which are reasonably large). Then programs themselves are running
>> at either real time class or normal class.
>>
>> The bug triggers when I exit the program (which are all of similar nature).
>>
>> I tried to reproduce this issue by doing random write using the 'seeker'
>> tool, but it didn't trigger. So it triggers specifically on existing the
>> program.
>>
>> You may like to install the Bitcoin qt wallet from your repositories
>> (maybe it's reproducible with bitcoind client also) and after a day or 2
>> of running with the above nilfs_cleanerd, try exiting the program. You
>> may trigger the bug.
> Great. Thank you. I'll try to reproduce the issue.
>
> One more question. Do you use this file system as rootfs or not? I
> suppose that it's not rootfs file system, as I remember your previous
> description of the issue.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>

Today I got a new set of errors.

[  127.915603] nilfs_direct_assign: invalid pointer: 0
[  127.915609] NILFS error (device sdc): nilfs_bmap_assign: broken bmap 
(inode number=202)

[  127.915611] Remounting filesystem read-only
[  127.915616] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348119040, ino 3
[  127.915620] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493821, size 1024
[  127.915622] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493822, size 1024
[  127.915624] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10742381, size 1024
[  127.915626] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5103281, size 1024
[  127.915629] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 202
[  127.915631] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  127.915633] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915635] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915637] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915640] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 6
[  127.915642] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7005068, size 1024
[  127.915644] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7005069, size 1024
[  127.915646] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5147173, size 1024
[  127.915648] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 4708314, size 1024
[  127.915650] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 454
[  127.915652] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6995811, size 1024
[  127.915654] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915656] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915658] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915660] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 5
[  127.915662] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7028502, size 1024
[  127.915664] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 1033179, size 1024
[  127.915666] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 1556797, size 1024
[  127.915668] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 2081912, size 1024
[  127.915670] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 129785856, ino 4
[  127.915672] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915674] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915676] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7028501, size 1024
[  127.915678] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915680] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348123136, ino 3
[  127.915682] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493823, size 1024
[  127.915684] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10742382, size 1024
[  127.915686] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493824, size 1024
[  127.915688] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5185507, size 1024
[  127.915691] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 24576, ino 6
[  127.915693] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915695] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915697] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915698] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7005070, size 1024
[  127.915701] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 12288, ino 5
[  127.915703] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6800054, size 1024
[  127.915705] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7028503, size 1024
[  127.915707] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5485077, size 1024
[  127.915709] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5990958, size 1024
[  127.915712] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 4
[  127.915714] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7028500, size 1024
[  127.915716] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915717] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915719] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  127.915722] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348127232, ino 3
[  127.915724] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815908, size 1024
[  127.915725] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5542116, size 1024
[  127.915727] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5249837, size 1024
[  127.915729] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5274639, size 1024
[  128.045093] ------------[ cut here ]------------
[  128.045105] WARNING: CPU: 1 PID: 7184 at fs/buffer.c:1166 
mark_buffer_dirty+0x6c/0x80()
[  128.045107] Modules linked in: nilfs2 fglrx(PO) kvm_intel sr_mod 
usb_storage cdrom kvm
[  128.045118] CPU: 1 PID: 7184 Comm: fuckcoind Tainted: P O 
3.14.8-gentoo #2
[  128.045120] Hardware name: Gigabyte Technology Co., Ltd. 
H61M-D2H/H61M-D2H, BIOS F5 05/18/2012
[  128.045122]  0000000000000009 ffffffff8155c03c 0000000000000000 
ffffffff8103e11d
[  128.045125]  ffff8802267bcf08 ffff8802242e0c60 ffff8801fa483c60 
00000000000081b0
[  128.045128]  ffff8802242e9000 ffffffff8111aefc ffff8801fa483c18 
ffffffffa0059231
[  128.045131] Call Trace:
[  128.045138]  [<ffffffff8155c03c>] ? dump_stack+0x49/0x6a
[  128.045143]  [<ffffffff8103e11d>] ? warn_slowpath_common+0x6d/0x90
[  128.045147]  [<ffffffff8111aefc>] ? mark_buffer_dirty+0x6c/0x80
[  128.045154]  [<ffffffffa0059231>] ? 
nilfs_palloc_commit_alloc_entry+0x11/0x60 [nilfs2]
[  128.045159]  [<ffffffffa00586b0>] ? 
nilfs_ifile_create_inode+0x80/0xf0 [nilfs2]
[  128.045164]  [<ffffffff81108556>] ? alloc_inode+0x26/0x90
[  128.045169]  [<ffffffffa0041474>] ? nilfs_new_inode+0x64/0x200 [nilfs2]
[  128.045175]  [<ffffffffa004fef0>] ? nilfs_near_disk_full+0x10/0x40 
[nilfs2]
[  128.045180]  [<ffffffffa0046223>] ? nilfs_create+0x43/0xf0 [nilfs2]
[  128.045184]  [<ffffffff81105419>] ? d_rehash+0x19/0x30
[  128.045187]  [<ffffffff810fdfad>] ? vfs_create+0x5d/0xb0
[  128.045190]  [<ffffffff810fe876>] ? do_last.isra.65+0x876/0xfd0
[  128.045193]  [<ffffffff810ff082>] ? path_openat+0xb2/0x600
[  128.045198]  [<ffffffff810ce903>] ? handle_mm_fault+0x213/0xa10
[  128.045202]  [<ffffffff810ffbd5>] ? do_filp_open+0x35/0x80
[  128.045206]  [<ffffffff8110b5d7>] ? __alloc_fd+0x97/0x120
[  128.045210]  [<ffffffff810f01d4>] ? do_sys_open+0x124/0x210
[  128.045215]  [<ffffffff81562a21>] ? tracesys+0xd4/0xd9
[  128.045217] ---[ end trace d5a322bab678392e ]---
[  132.929759] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 32768, ino 6
[  132.929766] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.929770] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.929773] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6995815, size 1024
[  132.929776] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.929789] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348131328, ino 3
[  132.929792] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5412791, size 1024
[  132.929795] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5321441, size 1024
[  132.929798] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5587311, size 1024
[  132.929801] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815910, size 1024
[  132.929805] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 495
[  132.929807] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929809] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929811] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929813] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929816] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 4096, ino 495
[  132.929818] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929820] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929822] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929824] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929826] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 8192, ino 495
[  132.929828] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929831] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929833] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929835] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929837] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 12288, ino 495
[  132.929839] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929841] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929843] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929845] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929847] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 16384, ino 495
[  132.929849] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929852] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929854] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929856] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929858] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 20480, ino 495
[  132.929860] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929862] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929864] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929866] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929868] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 24576, ino 495
[  132.929870] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929872] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929874] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929876] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929879] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 28672, ino 495
[  132.929881] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929883] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929885] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929887] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929889] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 32768, ino 495
[  132.929891] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929893] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929895] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929897] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929899] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 36864, ino 495
[  132.929901] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929903] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929905] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929908] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929910] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 40960, ino 495
[  132.929912] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929914] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929916] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929918] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929920] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 45056, ino 495
[  132.929923] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929925] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929927] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929929] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929931] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 49152, ino 495
[  132.929933] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929935] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929937] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929939] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929941] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 53248, ino 495
[  132.929943] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929945] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929947] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929949] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929953] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 57344, ino 495
[  132.929954] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929957] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929959] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929961] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929963] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 61440, ino 495
[  132.929965] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929967] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929969] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929971] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929973] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 65536, ino 495
[  132.929975] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929977] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929979] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929982] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929984] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 69632, ino 495
[  132.929986] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929988] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929990] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929992] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929994] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 73728, ino 495
[  132.929996] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.929998] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930000] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930002] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930005] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 77824, ino 495
[  132.930007] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930009] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930011] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930013] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930015] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 81920, ino 495
[  132.930017] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930019] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930021] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930023] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930025] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 86016, ino 495
[  132.930027] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930029] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930031] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930033] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930036] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 90112, ino 495
[  132.930038] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930040] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930042] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930044] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930046] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 94208, ino 495
[  132.930048] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930050] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930052] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930054] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930056] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 98304, ino 495
[  132.930059] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930061] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930063] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930065] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930067] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 102400, ino 495
[  132.930069] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930071] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930073] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930075] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930078] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 106496, ino 495
[  132.930080] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930082] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930084] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930086] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930088] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 110592, ino 495
[  132.930090] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930092] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930094] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930096] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930099] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 114688, ino 495
[  132.930101] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930103] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930105] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930107] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930109] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 118784, ino 495
[  132.930111] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930113] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930115] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930117] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930119] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 122880, ino 495
[  132.930121] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930123] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930125] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930127] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930130] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 126976, ino 495
[  132.930131] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930133] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930135] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930138] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930140] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 131072, ino 495
[  132.930142] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930144] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930146] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930148] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930150] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 135168, ino 495
[  132.930152] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930154] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930156] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930158] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930160] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 139264, ino 495
[  132.930162] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930164] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930166] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930168] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930171] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 143360, ino 495
[  132.930173] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930175] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930177] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930179] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930181] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 147456, ino 495
[  132.930183] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930185] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930187] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930189] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930191] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 151552, ino 495
[  132.930193] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930195] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930197] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930199] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930201] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 155648, ino 495
[  132.930203] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930205] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930207] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930209] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930212] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 159744, ino 495
[  132.930214] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930216] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930218] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930220] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930222] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 163840, ino 495
[  132.930224] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930226] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930228] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930230] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930233] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 167936, ino 495
[  132.930235] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930237] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930239] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930241] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930243] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 172032, ino 495
[  132.930245] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930247] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930249] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930251] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930254] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 176128, ino 495
[  132.930256] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930258] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930260] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930262] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930264] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 180224, ino 495
[  132.930266] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930268] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930270] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930272] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930274] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 184320, ino 495
[  132.930276] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930278] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930280] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930282] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930285] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 188416, ino 495
[  132.930286] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930289] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930291] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930293] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930295] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 192512, ino 495
[  132.930297] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930299] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930301] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930303] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930305] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 196608, ino 495
[  132.930307] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930309] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930311] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930313] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 0, size 1024
[  132.930316] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 679
[  132.930319] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 2147956, size 1024
[  132.930321] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.930323] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.930325] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.930329] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 57344, ino 6
[  132.930331] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.930333] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  132.930335] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6995816, size 1024
[  132.930337] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5795365, size 1024
[  132.930343] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348135424, ino 3
[  132.930345] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5412792, size 1024
[  132.930347] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815911, size 1024
[  132.930349] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5510902, size 1024
[  132.930351] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815912, size 1024
[  137.937681] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 61440, ino 6
[  137.937686] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  137.937689] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  137.937691] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  137.937693] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6995817, size 1024
[  137.937700] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348139520, ino 3
[  137.937703] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493825, size 1024
[  137.937705] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5571642, size 1024
[  137.937707] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5811858, size 1024
[  137.937709] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5674927, size 1024
[  142.945614] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 86016, ino 6
[  142.945619] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  142.945622] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 18446744073709551615, size 1024
[  142.945625] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 2148383, size 1024
[  142.945627] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6995818, size 1024
[  142.945635] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348143616, ino 3
[  142.945638] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5698245, size 1024
[  142.945640] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5698246, size 1024
[  142.945642] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6015801, size 1024
[  142.945644] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5763162, size 1024
[  147.953557] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 0, ino 6
[  147.953561] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7005068, size 1024
[  147.953564] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 7005069, size 1024
[  147.953565] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5147173, size 1024
[  147.953567] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 4708314, size 1024
[  147.953575] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348147712, ino 3
[  147.953577] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493826, size 1024
[  147.953578] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815916, size 1024
[  147.953580] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5828139, size 1024
[  147.953582] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493827, size 1024
[  152.961500] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348151808, ino 3
[  152.961505] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5869625, size 1024
[  152.961508] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6015802, size 1024
[  152.961510] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5901369, size 1024
[  152.961512] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5893217, size 1024
[  157.969410] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348155904, ino 3
[  157.969416] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815918, size 1024
[  157.969419] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493828, size 1024
[  157.969421] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493829, size 1024
[  157.969423] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5958880, size 1024
[  157.969432] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348160000, ino 3
[  157.969434] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493830, size 1024
[  157.969436] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6023894, size 1024
[  157.969438] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815920, size 1024
[  157.969441] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815921, size 1024
[  162.977339] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348164096, ino 3
[  162.977344] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6120506, size 1024
[  162.977346] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815922, size 1024
[  162.977348] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6169644, size 1024
[  162.977350] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493831, size 1024
[  167.985248] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348168192, ino 3
[  167.985252] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6151836, size 1024
[  167.985254] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493832, size 1024
[  167.985256] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6160650, size 1024
[  167.985258] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6239059, size 1024
[  172.993173] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348172288, ino 3
[  172.993178] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493833, size 1024
[  172.993181] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815925, size 1024
[  172.993183] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6280178, size 1024
[  172.993185] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6453546, size 1024
[  178.001115] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348176384, ino 3
[  178.001119] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6483090, size 1024
[  178.001122] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 3591231, size 1024
[  178.001124] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6374290, size 1024
[  178.001126] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815926, size 1024
[  183.009040] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348180480, ino 3
[  183.009045] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6419226, size 1024
[  183.009048] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493834, size 1024
[  183.009050] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6471246, size 1024
[  183.009052] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6617967, size 1024
[  188.016962] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348184576, ino 3
[  188.016966] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6560971, size 1024
[  188.016969] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10815927, size 1024
[  188.016971] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6617968, size 1024
[  188.016973] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6783847, size 1024
[  188.016981] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348188672, ino 3
[  188.016983] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6680286, size 1024
[  188.016986] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6666231, size 1024
[  188.016988] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6696427, size 1024
[  188.016990] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6759868, size 1024
[  193.024897] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348192768, ino 3
[  193.024902] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6759869, size 1024
[  193.024905] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6849594, size 1024
[  193.024907] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6744485, size 1024
[  193.024909] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6759870, size 1024
[  198.032814] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348196864, ino 3
[  198.032819] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493835, size 1024
[  198.032821] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6824997, size 1024
[  198.032823] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 9479863, size 1024
[  198.032825] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 6971932, size 1024
[  203.040755] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard page: offset 348200960, ino 3
[  203.040759] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 10806392, size 1024
[  203.040761] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 9560910, size 1024
[  203.040763] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 5493836, size 1024
[  203.040765] NILFS warning (device sdc): nilfs_clear_dirty_page: 
discard block 9560911, size 1024
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
