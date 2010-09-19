From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: nilfs error
Date: Sun, 19 Sep 2010 19:22:46 +0200
Message-ID: <4C9646E6.4090009@prnet.org>
References: <4C95A178.3020701@prnet.org> <20100919.213754.31465789.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100919.213754.31465789.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

  Hi,

there is one unimportant corrupted file. Is it safe to use the file 
system after removing this file or should I go the backup/restore route ?

Garbage collection was running when the problem appeared.

The disk is a 1tb disk and 16gb have been free.

Thanks in advance,
Bye,
David Arendt

On 09/19/10 14:37, Ryusuke Konishi wrote:
> Hi,
> On Sun, 19 Sep 2010 07:36:56 +0200, David Arendt wrote:
>>    Hi,
>>
>> yesterday I had the following error:
>>
>> Sep 18 18:03:24 server kernel: NILFS: bad btree node
>> (blocknr=226497086): level
>> = 37, flags = 0x18, nchildren = 22092
>> Sep 18 18:03:24 server kernel: NILFS error (device sdb1):
>> nilfs_truncate_bmap: b
>> map is broken (ino=69)
>> Sep 18 18:03:24 server kernel: Remounting filesystem read-only
>> Sep 18 18:03:24 server kernel: nilfs_palloc_commit_free_entry: entry
>> number 69 already freed
>>
>> Remounting the filesytem worked correctly. What could be the cause of
>> this error ?
> Thank you for the report.
>
> According to the log, nilfs detected btree corruption during file
> deletion; the message "bad btree node ..." shows a btree node block
> that nilfs read was broken.
>
> One possible cause is garbage collection, or there may be a problem
> with exclusion control on delete operation.  Or, the block might be
> actually broken if the underlying device is not reliable.
>
>
> Do you think nilfs_cleanerd worked before this trouble?
>
> How much free space was left on the device?
>
>> Should I preventively reformat the disk and recreate the
>> filesystem ?
> Yes, it's recommended for safety.  If you haven't yet reformatted the
> device, try the following command for sanity check.
>
>   # find /mount-dir -type f -exec cat {} \;>/dev/null
>
>
> Regards,
> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
