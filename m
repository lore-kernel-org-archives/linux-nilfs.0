From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Thu, 10 Jul 2014 21:13:47 +0530
Message-ID: <53BEB4B3.7000002@gmail.com>
References: <53ABA8F3.3010606@gmail.com>	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>	 <53ACF691.5090203@gmail.com> <1403850646.2588.4.camel@slavad-CELSIUS-H720>	 <53BB4B8B.4060902@gmail.com> <1404806620.2656.8.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=bMLYxoB9UlLClNR6lM5H6h3WDNcy2O8EBadURpPt6Nk=;
        b=J0lfUazWP3p0G/D0IUUjXyixKQGyNcEUSNLDRxlPbTchsH3cz+LClUz608QyF5UMQ9
         IQtB3aBgZDtjBfAeubLtZ1aOTyr3DwbXps3ptegEvuDkKcvWvLp1vh08Dgg6mVzQSoCq
         F1RJQkN8VS2BN9t11X9Zv3vq8EZfXYr8QdKlXaMgjNwoFCUuruoVUL5xhhcbqCPwiq1g
         YQCnrLsRIIB/R+MW7sdQQsLbn+huRZ1S2QU0VkgNsAV/VFAsFPIvhIAu37ckgFwT0dly
         FyFMZAemPutOdQpCOHThL1lVm4xwfr3n0JJKz4jAij2ZMZ9JbrpIzRKsJALtKoKBlxY/
         x56A==
In-Reply-To: <1404806620.2656.8.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/08/14 13:33, Vyacheslav Dubeyko wrote:
> On Tue, 2014-07-08 at 07:08 +0530, dE wrote:
>
> [snip]
>> Today I got a new set of errors.
>>
>> [  127.915603] nilfs_direct_assign: invalid pointer: 0
>> [  127.915609] NILFS error (device sdc): nilfs_bmap_assign: broken bmap
>> (inode number=202)
>>
>> [  127.915611] Remounting filesystem read-only
>> [  127.915616] NILFS warning (device sdc): nilfs_clear_dirty_page:
>> discard page: offset 348119040, ino 3
>> [  127.915620] NILFS warning (device sdc): nilfs_clear_dirty_page:
>> discard block 5493821, size 1024
> [snip]
>> [  128.045093] ------------[ cut here ]------------
>> [  128.045105] WARNING: CPU: 1 PID: 7184 at fs/buffer.c:1166
>> mark_buffer_dirty+0x6c/0x80()
>> [  128.045107] Modules linked in: nilfs2 fglrx(PO) kvm_intel sr_mod
>> usb_storage cdrom kvm
>> [  128.045118] CPU: 1 PID: 7184 Comm: fuckcoind Tainted: P O
>> 3.14.8-gentoo #2
>> [  128.045120] Hardware name: Gigabyte Technology Co., Ltd.
>> H61M-D2H/H61M-D2H, BIOS F5 05/18/2012
>> [  128.045122]  0000000000000009 ffffffff8155c03c 0000000000000000
>> ffffffff8103e11d
>> [  128.045125]  ffff8802267bcf08 ffff8802242e0c60 ffff8801fa483c60
>> 00000000000081b0
>> [  128.045128]  ffff8802242e9000 ffffffff8111aefc ffff8801fa483c18
>> ffffffffa0059231
>> [  128.045131] Call Trace:
>> [  128.045138]  [<ffffffff8155c03c>] ? dump_stack+0x49/0x6a
>> [  128.045143]  [<ffffffff8103e11d>] ? warn_slowpath_common+0x6d/0x90
>> [  128.045147]  [<ffffffff8111aefc>] ? mark_buffer_dirty+0x6c/0x80
>> [  128.045154]  [<ffffffffa0059231>] ?
>> nilfs_palloc_commit_alloc_entry+0x11/0x60 [nilfs2]
>> [  128.045159]  [<ffffffffa00586b0>] ?
>> nilfs_ifile_create_inode+0x80/0xf0 [nilfs2]
>> [  128.045164]  [<ffffffff81108556>] ? alloc_inode+0x26/0x90
>> [  128.045169]  [<ffffffffa0041474>] ? nilfs_new_inode+0x64/0x200 [nilfs2]
>> [  128.045175]  [<ffffffffa004fef0>] ? nilfs_near_disk_full+0x10/0x40
>> [nilfs2]
>> [  128.045180]  [<ffffffffa0046223>] ? nilfs_create+0x43/0xf0 [nilfs2]
>> [  128.045184]  [<ffffffff81105419>] ? d_rehash+0x19/0x30
>> [  128.045187]  [<ffffffff810fdfad>] ? vfs_create+0x5d/0xb0
>> [  128.045190]  [<ffffffff810fe876>] ? do_last.isra.65+0x876/0xfd0
>> [  128.045193]  [<ffffffff810ff082>] ? path_openat+0xb2/0x600
>> [  128.045198]  [<ffffffff810ce903>] ? handle_mm_fault+0x213/0xa10
>> [  128.045202]  [<ffffffff810ffbd5>] ? do_filp_open+0x35/0x80
>> [  128.045206]  [<ffffffff8110b5d7>] ? __alloc_fd+0x97/0x120
>> [  128.045210]  [<ffffffff810f01d4>] ? do_sys_open+0x124/0x210
>> [  128.045215]  [<ffffffff81562a21>] ? tracesys+0xd4/0xd9
>> [  128.045217] ---[ end trace d5a322bab678392e ]---
> I suppose that these error messages are sequence of the initially
> reported issue. Namely, your GC doesn't work because of the issue and
> NILFS2 volume has exhausted yet. As a result, the file system is
> remounted in RO mode. Messages about discarding dirty pages take place
> after remounting in RO mode in the case of trying to flush dirty pages.
>
> Sorry, unfortunately, I have the crazy month and I can't find
> opportunity for investigation of the issue. I hope that I'll have such
> opportunity soon.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>

Thanks for your corporation. I'll keep reporting whatever I can. Right 
now I'm trying with 2048 block size.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
