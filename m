From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_check_page: bad entry in directory #37945
Date: Tue, 17 Mar 2009 20:06:09 +0900 (JST)
Message-ID: <20090317.200609.69369815.ryusuke@osrg.net>
References: <20090317.000905.79144599.ryusuke@osrg.net>
	<20090317.002333.93458556.ryusuke@osrg.net>
	<49BECFDF.1060802@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <49BECFDF.1060802-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

Hi,
On Mon, 16 Mar 2009 23:17:03 +0100, David Arendt wrote:
> Hi,
>
> I also received numerous nilfs related error messages. I have
> attached them to the end of this mail.  As the backup of yesterday
> worked flawlessly, the corruption must have occured today.
>
> As I am doing video editing on nilfs2 filesystems, and so I don't want
> the cleaner to interfere with it, I always do mount -i and if I am short
> on space, I call the cleaner manually and send it a SIGTERM signal, once
> I see no more cleaning activity. I have modified the number of segments
> to clean from 2 to 20 in order to speed up cleaning.
> 
> As this moring, I had 95% of used space, I called the cleaner manually.
> The cleaner seemed to work normally so after there was no more disk
> activity, I sent it a SIGTERM signal. As I am running on gentoo, I did
> an emerge --sync followed by an emerge --update --deep --ask world, so
> there was lots of io on this partition (it was the root one). During
> this, the system crashed completely  without reaction to any key. As I
> find no data on this crash in the log files, I can't say if the nilfs
> corruption was leading to this crash or if this crash was leading to the
> nilfs corruption.

Thank you for the detail report.

We are now testing nilfs under such high capacity condition.

I first suspected a problem of directory implementation, but now it
seems to be corruption involved with GC.

I suspect that your nilfs had read blocks which were reclaimed by
clearnerd and overwritten by new logs for some reason.

The cycle of reusing segments will be shorter than usual in such case.
So, it's a likely cause though we carefully designed nilfs not to
suffer such trouble.

Another possibility is that the secondary superblock introduced in
nilfs-2.0.10 broke an in-use segment.  If the corruption will not
occur for nilfs-2.0.9, it would be the cause.

> After this crash, I first saw error messages from nilfs.
>
> I did a dd if=/dev/sda3 of=imagefile bs=8192 of the partition prior to
> the restore, so if you like to further investigate into this, the
> corrupted partition is still mountable via a loop device. If this data
> is useless for you, please tell me so, then I will delete the image file.
> 
> Bye,
> David Arendt

Could we have some time?  If we can reproduce the problem, it is the
best.  If we cannot, I'd like to ask for more help.

Sorry for inconvenience.

Regards,
Ryusuke Konishi

Ryusuke Konishi wrote:
> On Tue, 17 Mar 2009 00:09:05 +0900 (JST), Ryusuke Konishi wrote:
>   
>> Hi David,
>> On Mon, 16 Mar 2009 11:18:13 +0100, David Arendt wrote:
>>     
>>> Hi,
>>>
>>> this morning I discovered this in /var/log/messages
>>>
>>> Mar 16 10:59:00 server NILFS error (device sda3): nilfs_check_page: bad
>>> entry in directory #37945: unaligned directory entry - offset=0,
>>> inode=1919250021, rec_len=14411, name_len=67
>>>
>>> I am using nilfs 2.0.10.
>>>
>>> What should I do about this error ? Should I ignore it or should special
>>> care be taken about it ?
>>>
>>>       
>> offset=0 --> first entry of the directory.
>> inode=1919250021 --> unnatural inode number. seems invalid.
>> rec_len=14411 --> invalid.
>>
>> So, this directory is completely broken. Maybe b-tree of the directory
>> is pointing to a wrong block.
>>
>> Is this reproducible by umount/mount and ls -R ?
>>     
>
> The directory's inode number was shown in the log!
> You can find it by:
>
>  $ find /mount-dir -inum 37945 -ls
>
>
> Regards,
> Ryusuke Konishi
