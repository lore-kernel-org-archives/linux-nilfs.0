From: KARBOWSKI Piotr <piotr.karbowski-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [!] Unable to mount nilfs2 filesystem after power outage - error
 loading super root.
Date: Fri, 18 Mar 2016 21:40:02 +0100
Message-ID: <56EC67A2.8050905@gmail.com>
References: <56EC45FD.7010808@gmail.com>
 <1458331991.2615.6.camel@slavad-ubuntu-14.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=TqpVo9r1P6eI6ydoIuVVhcOHH7fRgpRVi3yV1djM8Iw=;
        b=HTWvL7Pihaw1UTNRSRsowVRPXDNCvlzNY3HquttPVYpKTkcXTge0ekbHx6W/ENyrAr
         SFKUNDnrOE4TlIes1j5ohBSvwaXIM0wtEOYip6PRLCJpqRttGNRao+lb5Mur/TbDVQlX
         +976U5MYm6z3U0alT3YqrrG2q1IoHU5OUyi1iGPcQ0fVxpk6xN5M7WdXnWBal3mH2QiY
         RWXEkeSg3VOIeoHK9ZxJXPBfoXj4C49o2hWmjjBBNlrO9jclLcrEEU97STLg7wAr2zFO
         KsMfb/waPUEJ4NuJV7QLeqwgmbwjWu88dYPKQSpEyDkHNTiB9xJMH+17xuydXZbcKTda
         6QRQ==
In-Reply-To: <1458331991.2615.6.camel-dzAnj6fV1RzTdvqWZYKEhEEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 03/18/2016 09:13 PM, Viacheslav Dubeyko wrote:
> On Fri, 2016-03-18 at 19:16 +0100, KARBOWSKI Piotr wrote:
>> Hi,
>>
>> Yesterday I had an power outage. After booting my notebook again, I was
>> no longer able to mount /home that was on the top of nilfs2 filesystem.
>>
>> I've come across a post from 2011 about fsck in git.nilfs.org but that
>> repo is no longer accessable. The repo from githab does not have any
>> trace of the experimental fsck tool thus I've dumped the filesystem to
>> image, recreated ext4 and restored backup.
>>
>
> NILFS2 hasn't fsck utility. And no implementation efforts exist.

I was refering to http://marc.info/?l=linux-nilfs&m=130799952525081&w=2

>> The symptoms:
>>
>> # mount -o loop ./kurogane_ssd-home.17.03.2016.img /mnt/tmp
>> mount.nilfs2: Error while mounting /dev/loop/0 on /mnt/tmp: No such file
>> or directory
>>
>> # dmesg
>> [ 9591.626210] NILFS warning: mounting unchecked fs
>> [ 9591.824166] NILFS: error loading super root.
>>
>
> Do you have any NILFS2 related errors before mount operation in your
> syslog? Does strace show something interesting for mount operation?

Nothing special. Right now all I have is a image of the filesystem, and 
just the two lines are printed when I try to mount it. Strace does not 
provide anything useful

     mount("/dev/loop/1", "/mnt/tmp", "nilfs2", MS_MGC_VAL, NULL) = -1 
ENOENT

>> No nilfs-utils's tools works beside the tune with -l
>>
>> # nilfs-tune -l /dev/loop1
>> nilfs-tune 2.2.2
>> Filesystem volume name:	  home
>> Filesystem UUID:	  6a915104-61d5-4214-bed4-2538d1bdfaa5
>> Filesystem magic number:  0x3434
>> Filesystem revision #:	  2.0
>> Filesystem features:      (none)
>> Filesystem state:	  invalid or mounted
>> Filesystem OS type:	  Linux
>> Block size:		  4096
>> Filesystem created:	  Sat Nov 14 14:40:18 2015
>> Last mount time:	  Thu Mar 17 17:41:23 2016
>> Last write time:	  Thu Mar 17 22:46:08 2016
>> Mount count:		  154
>> Maximum mount count:	  50
>> Reserve blocks uid:	  0 (user root)
>> Reserve blocks gid:	  0 (group root)
>> First inode:		  11
>> Inode size:		  128
>> DAT entry size:		  32
>> Checkpoint size:	  192
>> Segment usage size:	  16
>> Number of segments:	  11294
>> Device size:		  94745133056
>> First data block:	  1
>> # of blocks per segment:  2048
>> Reserved segments %:	  5
>> Last checkpoint #:	  1016585
>> Last block address:	  17023836
>> Last sequence #:	  80736
>> Free blocks count:	  6764544
>> Commit interval:	  0
>> # of blks to create seg:  0
>> CRC seed:		  0x60cb4676
>> CRC check sum:		  0x68371ded
>> CRC check data size:	  0x00000118
>>
>> This is something I woudn't expect from a log structured filesystem. I
>> am running kernel 4.5.0.
>>
>
> Any software has bugs. NILFS2 needs in testing and stabilization yet.
> So, even if NILFS2 is LFS then it's software that contains bugs.
>> Any comments and help with restoring access to this fs much appriecieate
>>
>
> It's possible to try to investigate your issue but no promise about
> recovering corrupted NILFS2 volume. We haven't any tools for it. But if
> you are ready then you could implement such tool(s).



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
