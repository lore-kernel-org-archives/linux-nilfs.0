From: Keith <kperry-SsverHGN8JZ0+Iju73vM4UEOCMrvLtNR@public.gmane.org>
Subject: Re: Is NILFS2 suitable for long term archival storage?
Date: Tue, 21 Jun 2022 12:03:33 -0400
Message-ID: <bbaf111e-34c8-02d8-da52-a95d474b7210@daotechnologies.com>
References: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/21/22 05:40, Ciprian Craciun wrote:
> [I'm not subscribed to the mailing list, thus please keep me in CC.]
>
>
> I was looking at NILFS2 as a potential solution for a file-system for
> long-term archival (as in backups or append-only store).  In this
> use-case I would use large CMR or SMR rotational disks (say 4+ TB, WD
> or Seagate) without any RAID or disk-encryption, connected via USB
> (thus sudden disconnects are to be expected), used with `restic`, or
> `rdiff-backup` and `rsync`-like if `restic` doesn't work.  As such,
> the IO pattern during backup would be mostly creating new files, a
> couple MiB each in case of `restic`, and random reads during `restic`
> checks.  In both cases there is quite some concurrency (proportional
> to the number of cores).
>
> So I was wondering the following:
> * is NILFS2 suitable for such a use-case?  (my assumption is yes, at
> least based on the features and promises;)
> * how reliable is the current version (as upstreamed in the kernel) of
> NILFS2?  data-loss of previously written (and `fsync`-ed) files is of
> paramount importance (especially for files that have been written say
> days ago);
> * are there instances of NILFS2 used in production (for any use-case)?
I use nilfs2 in similar ways and have been for well over 10 years now.  
I use it in a mostly as part of a data replication solution (single or 
multi-stage).  I would mostly recommend it for windowed backup and 
archival solutions (i.e. we're going to keep X amount of data for Y 
amount of time and purge every Z interval).
> I've tried searching on the internet and the email archives, but I
> couldn't find anything "current" enough.  Moreover at least OpenSUSE
> (and SUSE) have dropped the NILFS2 kernel module from the standard
> packages (granted JFS was also dropped).
>
> Also I'm concerned due to the fact that there isn't any `fsck` for NILFS2 yet.
>
This is why I don't 100% recommend it.  I have had no more than 4 major 
issues in 10 years where I could not purge old data. Specifically what 
that means is I had a snapshot that changed back to a checkpoint so that 
it could be purged the next time garbage collection ran.  As a result, I 
eventually had to reformat which meant giving up the current data (which 
could span several years). I sometimes use an nilfs2 fs in a loop 
mounted system on top of a large parallel / distributed filesystem and 
that combination could be the issue but it makes no sense to me why 
there is no way to get around a problem like that.  The lack of tools to 
analyze and fix that condition or to be able to efficiently copy or 
migrate data to another system continues to be an issue.  That said, I 
have NEVER lost data in snapshot and have been able to access data from 
years prior even when I can't purge.  The benefits of nilfs2 continue to 
outweigh this issue for me and if I really want all the data in a 
filesystem that can't be purged I could rebuild it manually somewhere 
else on the data lake.  That would be a p.i.t.a. but at least it is an 
option.
> Related to this, could the community recommend an alternative
> file-system that would fit the bill?  (Ext4 and JFS are the only
> file-systems I have heavily used and relied upon.)
>
Nothing else comes to mind for me as an all-in-one-solution.  I think 
you're going to have to continue to build a solution from the best 
offerings you find.

-- 
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
Keith C. Perry, MS E.E.
Managing Member, DAO Technologies LLC
(O) +1.215.525.4165 x2033
(M) +1.215.432.5167
www.daotechnologies.com

