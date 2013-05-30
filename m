From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 30 May 2013 17:30:48 +0200
Message-ID: <51A770A8.9070105@antoneliasson.se>
References: <519D2B96.9000106@antoneliasson.se>  <1369291449.2673.15.camel@slavad-ubuntu>  <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se> <1369809573.2253.31.camel@slavad-ubuntu> <51A70971.40602@antoneliasson.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A70971.40602-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Anton Eliasson skrev 2013-05-30 10:10:
> Vyacheslav Dubeyko skrev 2013-05-29 08:39:
[snip]
>> Current state of fsck.nilfs2 doesn't give many useful details. But debug
>> output of fsck.nilfs2 contains detailed info about first superblock,
>> second superblock and segment summaries of all segments. I think that
>> this output can give to me more understanding about NILFS2 volume state.
>> Could you share debug output of fsck.nilfs2 for me?
>>
>> You can found archive with fsck.nilf2 source code in this place:
>> (http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz).
>> Please, build fsck.nilfs2 but don't install it. The fsck.nilfs2 on the
>> initial state of development. Currently, fsck.nilfs2 doesn't make any
>> writing operations. So, you can execute command in such way:
>> "fsck.nilfs2 -v debug [device] 2> [output-file]". The output file has
>> a big size, usually.
> I'll see if I can do that tonight.

Okay, this is what was printed to stdout by fsck.nilfs2 with debug 
verbosity:

fsck.nilfs2 v.0.04-under-development (nilfs-utils 2.1.4)
[UI_INFO]: The NILFS superblocks checking begins.
[FS_INFO]: [SB] [ID: 0x10200020000005f] [SEG: 0 LOG: 0] Superblock state 
flag *tells* that filesystem stays in mounted state.
[FS_INFO]: [SB] [ID: 0x10200020000006a] Primary and secondary 
superblocks have different info about last checkpoint.
[FS_INFO]: [SB] [ID: 0x10200020000006b] Primary and secondary 
superblocks have different info about disk block address of partial segment.
[FS_INFO]: [SB] [ID: 0x10200020000006c] Primary and secondary 
superblocks have different info about sequential number of partial segment.
[FS_INFO]: [SB] [ID: 0x102000200000070] Primary and secondary 
superblocks have different last write time.
[FS_INFO]: [SB] [ID: 0x102000200000073] Primary and secondary 
superblocks have different file system state flags.
[FS_INFO]: [SB] [ID: 0x10200020000003d] NILFS has valid primary and 
secondary superblocks.
[INTERNAL_INFO]: NILFS has valid primary and secondary superblocks. 
Requested device: /dev/riven/home.
[UI_INFO]: NILFS volume's segments checking begins.
[UI_INFO]: FSCK currently has partial and experimental checking 
functionality. Sorry. Functionality is not implemented yet.
[UI_INFO]: All is OK. Have a nice day.

And here's the log that was printed to stderr: 
http://antoneliasson.se/publicdump/riven-home-fsck-stderr.log.gz
It's 12 MB gzipped and 457 MB uncompressed.

-- 
Best Regards,
Anton Eliasson
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
