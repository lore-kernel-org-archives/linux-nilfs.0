From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Mon, 27 May 2013 14:45:12 +0200
Message-ID: <51A35558.1080503@antoneliasson.se>
References: <51A0A97A.4020503@antoneliasson.se> <713B7146-DC0C-45AE-9ED2-30EB8F84FA57@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <713B7146-DC0C-45AE-9ED2-30EB8F84FA57-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org

Vyacheslav Dubeyko skrev 2013-05-26 14:59:
> Hi Anton,
>
> On May 25, 2013, at 4:07 PM, Anton Eliasson wrote:
>
>>
> Thank you for additional details.
>
> But, as I remember, Ryusuke asked to try such commands too:
>
> $ sudo nilfs-tune -l /dev/dm-3
> $ sudo dumpseg /dev/dm-3 7007
> $ lssu -a /dev/dm-3
>
> Could you share output of these commands?
>
>
My messages are being silently swallowed! Maybe your list doesn't like 
my attachments? This is the third attempt and this time without attachments.

Ryusuke Konishi skrev 2013-05-23 03:40:
  > Hi,
  > On Wed, 22 May 2013 22:36:02 +0200, Anton Eliasson wrote:
  >> Anton Eliasson skrev 2013-05-22 22:33:
  >>> Greetings!
  >>> It pains me to report that my /home filesystem broke down today. My
  >>> system is running Arch Linux 64-bit. The filesystem resides on a
  >>> Crucial M4 256 GB SSD, on top of a LVM2 volume. The drive and
  >>> filesystem are both around six months old. Partition table and error
  >>> log excerpts are at the bottom of this e-mail. Full logs are available
  >>> upon request.
  >>>
  >>> I am providing this information as a bug report. I have no reason to
  >>> suspect the hardware but I cannot exclude it either. If you (the
  >>> developers) are interested in troubleshooting this for prosperity, I
  >>> can be your hands and run whatever tools are required. If not, I'll
  >>> reformat the filesystem, restore the data from backup and forget that
  >>> this happened.
  >>>
  >>> In case the formatting gets mangled, this e-mail is also available at
  >> Right here: http://paste.debian.net/5841/
  > Thank you for the report.
  >
  > According to the log, btree of a regular file is destroyed for some 
reason.
  > I think we should look into how the btree block is broken.
  >
  > Could you try the following commands to inspect the broken disk 
segment ?
  >
  >   $ sudo dd if=/dev/dm-3 bs=4k count=2048 skip=14350336 iflag=direct 
2>/dev/null | hexdump -C
There's some semi-private stuff in there so I'll e-mail it separately to 
Ryusuke Konishi and Vyacheslav Dubeyko.
  >
  > This will print out blocks of the segment 7007 which includes the
  > broken btree block.
  >
  > The following commands are also useful to get debug information.
  > Could you try them, too ?
  >
  >   $ sudo nilfs-tune -l /dev/dm-3
Today (May 23) it's called dm-2 but I don't think that should matter.

nilfs-tune 2.1.5
Filesystem volume name:      home
Filesystem UUID:      e4e8bd9a-12f6-4c2a-b32f-9471f1b321fc
Filesystem magic number:  0x3434
Filesystem revision #:      2.0
Filesystem features:      (none)
Filesystem state:      invalid or mounted,error
Filesystem OS type:      Linux
Block size:          4096
Filesystem created:      Sat Oct  6 15:52:11 2012
Last mount time:      Sat May 25 10:42:30 2013
Last write time:      Sat May 25 10:42:30 2013
Mount count:          143
Maximum mount count:      50
Reserve blocks uid:      0 (user root)
Reserve blocks gid:      0 (group root)
First inode:          11
Inode size:          128
DAT entry size:          32
Checkpoint size:      192
Segment usage size:      16
Number of segments:      14039
Device size:          117771862016
First data block:      1
# of blocks per segment:  2048
Reserved segments %:      5
Last checkpoint #:      1260585
Last block address:      430080
Last sequence #:      1557848
Free blocks count:      10317824
Commit interval:      0
# of blks to create seg:  0
CRC seed:          0xfb8deb0b
CRC check sum:          0x0db18bf2
CRC check data size:      0x00000118

  >   $ sudo dumpseg /dev/dm-3 7007
http://antoneliasson.se/publicdump/dumpseg-home-Anton_Eliasson-20130525.gz
  >   $ lssu -a /dev/dm-3
I ran this on May 23 but haven't had time to compose this e-mail until 
two days ago. During that period I mounted the filesystem as rw once or 
twice and I unfortunately forgot to kill nilfs_cleanerd so some of the 
segments might have moved around. So I have rerun lssu and uploaded both 
outputs here:
http://antoneliasson.se/publicdump/lssu-Anton_Eliasson-20130523.gz
http://antoneliasson.se/publicdump/lssu-Anton_Eliasson-20130525.gz
  >
  > The third command requires the device is mounted, so /home should be
  > mounted previously with a readonly option and a norecovery option:
  >
  >   $ sudo mount -t nilfs2 -o ro,norecovery /dev/dm-3 /home
  >
Additionally, I have uploaded /var/log/everything.log spanning May 19-22 
here:
http://antoneliasson.se/publicdump/everything.log.gz

The first system crash is on line 14748. On line 15829 onwards nilfs 
warns that an fs is unchecked and has a bad checksum. On line 16206 is 
the first bad btree node error. I copied the entire /var/log tree a 
reboot or two after I figured out that I had a bad fs. Please tell me if 
you need any other log files from there.

-- 
Best Regards
Anton Eliasson


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
