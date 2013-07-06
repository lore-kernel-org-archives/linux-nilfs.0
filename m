From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: searching checkpoints contaning an inode (or a filename)
Date: Sat, 06 Jul 2013 18:50:38 +0900 (JST)
Message-ID: <20130706.185038.523614087.konishi.ryusuke@lab.ntt.co.jp>
References: <20130705201701.GE23851@taesoo.org>
	<B16ADF79-9EF9-46E8-95F8-9D4815E86C64@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B16ADF79-9EF9-46E8-95F8-9D4815E86C64-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 6 Jul 2013 11:34:32 +0400, Vyacheslav Dubeyko wrote:
> Hi Taesoo,
> 
> On Jul 6, 2013, at 12:17 AM, Taesoo Kim wrote:
> 
>> Hi nilfs,
>> 
>> I am evaluating nilfs for using it in my machine. There are a few
>> questions regarding usages:
>> 
>> q1. how can I enumerate a list of cps, given a filename?
>> (I know I can mount each cp to check whether there is my file or
>> not, as time-machine (in mac) does)
>> 

I think it's hard to implement this feature efficiently because nilfs
doesn't have an efficient lookup method of past inodes from a file
name.

> You can use dumpseg fot this goal. To be honest this way not so
> simple. You can get inode id from ls output ("ls -i"), for example.
> And then you need to get dumpseg for all segments and select
> output for searching inode. Of course, it needs to implement
> special feature for easy retrieving such data. 

dumpseg is a debug tool and it doesn't provide a solid way since it
directly scans on-disk blocks from userland.

We should adds an ioctl for that if there is a reasonable purpose, but
I don't know it can be implemented nicely.

>> q2. compute diff or cat against previous files in a specific cp?
>> (instead of mounting and copying them individually to my /tmp)
>> 
> 
> As I understand, currently, we haven't this as feature of any
> NILFS2's tool or internal file system technique.

An experimental patchset and a tool exist:

http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00827.html

nilfs-diff:

   git://github.com/konis/nilfs-utils.git (diff branch)

diff API:

   git://github.com/konis/nilfs2.git (diffapi branch)


But I have never sent this to the mainline because the patchset has
important limitations for practical use in addition to needing a disk
format change.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
