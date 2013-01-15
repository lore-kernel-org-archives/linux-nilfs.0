From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Tue, 15 Jan 2013 19:43:50 +0900
Message-ID: <201301151043.AA04492@capsicum.lab.ntt.co.jp>
References: <1358234057.2105.12.camel@slavad-ubuntu>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358234057.2105.12.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,
>On Mon, 2013-01-14 at 16:54 +0100, Sven Eckelmann wrote:
>> The filesystem can end up in a state were the filesystem is full and the
>> returned ss_nongc_ctime is smaller than sui_lastmod of all reclaimable
>> segments. The garbage collector will not clean anything and therefore no new
>> room for new files will be available and ss_nongc_ctime/sui_lastmod will not be
>> updated without using special tools. This makes the filesystem unusable without
>> manual recovery.
>> 
>> Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
>> --
>> This problem appeared on a current 3.2 stable kernel (Debian Wheezy build). I
>> am not an FS developer and have therefore not much background knowledge about
>> the NILFS codebase. Nevertheless, this problem hit me quite hard after creating
>> some files on a nilfs partition until it was full and deleting them again.
>> 
>> $ for i in `seq 0 150`; do dd if=/dev/zero of=foo$i count=22528; done
>> $ rm foo*
>> 
>> Looking at the output debugging output using
>> 
>> $ watch -n .5 'df -h;tail /var/log/syslog;'
>> 
>> clearly showed that it was not finding any segments to delete. The only problem
>> I could find was the threshold. After "removing" this threshold, I was able to
>> get some clear segments again. I personally cannot explain why the check is
>> there at all. Maybe there is a good reason but the comment above it didn't help
>> much.
>> 
>> So, here for completeness the threshold: 1358164666 (aka: Mon Jan 14 12:57:46
>> CET 2013)
>> 
>> And here are the output of lssu and lscp:
>> 
>> $ lssu --all
>> SEGNUM        DATE     TIME STAT     NBLOCKS
>> 0  2013-01-14 12:58:23  -d-        2047
>> 1  2013-01-14 12:58:23  -d-        2048
>
>[snip]
>
>> 
>> Signed-off-by: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
>> ---
>>  sbin/cleanerd/cleanerd.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/sbin/cleanerd/cleanerd.c b/sbin/cleanerd/cleanerd.c
>> index bfcd893..12ed975 100644
>> --- a/sbin/cleanerd/cleanerd.c
>> +++ b/sbin/cleanerd/cleanerd.c
>> @@ -592,7 +592,7 @@ nilfs_cleanerd_select_segments(struct nilfs_cleanerd *cleanerd,
>>  	 * selected. */
>>  	thr = (config->cf_selection_policy.p_threshold != 0) ?
>>  		config->cf_selection_policy.p_threshold :
>> -		sustat->ss_nongc_ctime;
>> +		~0ULL;
>>  
>
>As I understand the code of nilfs_cleanerd, this code is correct without
>your changing. The ss_nongc_ctime is the creation time of the last
>segment not for GC. When thr is set then it compared with sui_lastmod.
>The sui_lastmod is the timestamp of last modification. So, the
>nilfs_cleanerd works right.
>
>I think that this is a bug on the kernel side. My current vision is that
>in some environment the ns_nongc_ctime can be not updated correctly. So,
>you have such threshold that prevent from segments clearing.

I guess the problem is caused because ss_nongc_ctime is not updated by
the kernel module if dirty blocks created by file operations are written
out through nilfs_clean_segments function.   Actually,
nilfs_clean_segments() can roll together normal dirty blocks.

So, if GC is working without interruption, ss_nongc_ctime may not be
updated long time.

If this is the cause of the problem, nilfs2 log writer should be changed
so that nilfs->ns_nongc_ctime is updated with sci->sc_seg_ctime if
there is a file system change (file/directory change or an ifile change).

NILFS_SC_HAVE_DELTA flag may be available for this purpose.

The ss_nongc_ctime check is needed to make GC stoppable.
Without this check, GC can continue endlessly even if the file system
doesn't have any change.

With regards,
Ryusuke Konishi

>Thank you for the issue report.
>
>With the best regards,
>Vyacheslav Dubeyko.
>
>>  	for (segnum = 0; segnum < sustat->ss_nsegs; segnum += n) {
>>  		count = (sustat->ss_nsegs - segnum < NILFS_CLEANERD_NSUINFO) ?
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
