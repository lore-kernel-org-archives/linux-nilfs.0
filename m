From: Ciprian Craciun <ciprian.craciun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is NILFS2 suitable for long term archival storage?
Date: Wed, 22 Jun 2022 17:37:41 +0300
Message-ID: <CA+Tk8fywv3sL1wLcZioWACCBfMPpDCqrKEXnvuzH0q6GP9FCWA@mail.gmail.com>
References: <CA+Tk8fzpXneoDAyvdoJFdFjX7Cx-cJ7GO0uNXjGrYDk23FyekA@mail.gmail.com>
 <YrMHJYobUpjv+KRj@kelsos>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=VIjNoMrU30pbhQsSzli50cyFkAqfKHz6EgWSSD1tVS0=;
        b=pmUdwLNEBudvfjjJWmzBlhYpZcWFEFGfviF0rfCvWErnElAxJNhrjlyuYNItlrYDrq
         mJ9zuW/2Caw22JH/++oikeSPPgT2aAxd78Sm0jonZ3eY1CO2tl+/vS1CeAWqPun86YZO
         hPU/Sawv14WcQHg3eJFsdXD1ygXtXrvdU2gDqdaeVikHpQUk7kSiFq3k4qyx8jUmchGv
         BqgfVoDtV+a3iFSEkJYsyLgCS+lVP3KiJldWT7MnJeU08STNdL/9ZGW3j7WU3TQcsjX3
         FbJngi8+2NvtSlMVAoIN7vsFnDu6D7TQkoU24sMFTLm2pAwpvQooeGdHSEBAIMpv14Kv
         nBHA==
In-Reply-To: <YrMHJYobUpjv+KRj@kelsos>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[I'm replying to multiple emails at the same time.]
[I'm not subscribed to the mailing list, thus please keep me in CC.]



On 6/21/22 18:02, Ryusuke Konishi wrote:
> The suitability for storage media such as CMR and SMR is uncertain in
> actual use, so I think you should actually evaluate that pattern with some
> file systems.


Although I would prefer CMR (and so far I don't have any SMR disk), I
think sooner or later all large rotational disks would migrate towards
SMR, perhaps with the exception of enterprise disks (which aren't very
affordable, like the WD Gold series).  For example for my backups I
intend to use the "video archival" disks from Seagate (Sky Hawk
series) and Western Digital (Purple series), both lines having CMR and
SMR, but the CMR variants seem to be pushed towards phasing out.  I
have no concrete reasons to back this intention, except that Backblaze
seems to favor these "video archival" disks, and the fact that they
are cheaper than NAS or even desktop drives.



On 6/21/22 18:02, Ryusuke Konishi wrote:
> Writing with NILFS2 has the characteristic of being sequential, including
> updating file system metadata and concurrent writes.  However, reading
> causes random access, which will be a trade-off with the effect of caching.
>
> In addition, NILFS2 periodically updates the superblocks at the beginning
> and end of the partition alternately, so writes are not completely sequential.
> These properties can work in both the good and the bad.


Indeed, in case of SMR disks, completely sequential writes should
cause no problem (as I understand their operating principles).

Regarding the writing at the beginning and end of disks for the super
blocks, I think (and this is a speculation based on some proposals
I've seen in Linux about special file-systems to handle "zoned
drives") some SMR disks have CMR properties at least at the beginning
of the disk (and one hopes at the end also).  However this would force
one to practically not use any partitioning, or just making one large
partition that spans the entire disk.

Regarding random reads, I don't think there is any performance penalty
(as compared to CMR).  Also, given that NILFS2 is practically a
sequential log, I would expect there to be more random reads than in
other file-systems, especially for folder contents.  However, at least
in the case of `restic`, this shouldn't be a problem as it doesn't
generate extreme number of files (in my case for ~1.6 TiB worth of
data it only uses ~320K inodes, that is around ~5 MiB per inode), and
it definitively doesn't change exiting ones.



On 6/21/22 18:02, Ryusuke Konishi wrote:
> For sudden removal, NILFS2 will be robust as the result of checkpointing,
> but that assumption, in the first place, sounds physically not good for
> disk media unless the device has a battery-backed safety guarantee.
> On the other hand, most modern file systems these days are also robust
> enough for unusual disconnections.


At least for this use-case (long term backups) I'm not concerned in
losing "recent" data (as in say a couple of minutes old);  I am
concerned of total loss of data after a sudden power loss.  (I've seen
this happen twice already with XFS, once with LVM thin provisioning,
and once with ReiserFS.)



On 6/21/22 18:02, Ryusuke Konishi wrote:
> The use case where NILFS2 is most useful is that the latest data can be
> recovered even if the data is overwritten or deleted by human error or an
> application bug.
>
> However, this does not seem to be utilized in the above archive storage
> applications.

[plus what Tommy said]

On 6/22/22 15:12, Tommy Pettersson wrote:
> Even if safety is not a priority, there is little benefit
> from using nilfs2 for backups, since you will probably make
> a manual snapshots after a backup anyway, and not have any
> use for all the automatic checkpoints that will be created
> during the backup.


In fact, the check-pointing feature of NILFS2 is exactly what prompts
me to investigate its usage.  `restic` already does a good job in
snapshoting and deduplicating the backed-up files.  However my concern
is, as you've described, something going wrong with some custom
script, `restic` itself, or operator, and files are just deleted or
overwritten.  When this happens, NILFS2 should just allow me to go
back in time and undo the changes.  (In fact, to make sure no data is
lost, I intend to mount it with GC disabled, and let that be a
deliberate and explicit operational concern.)  Moreover having NILFS2
snapshots allows me to interact with older variants of the `restic`
repository, as some `restic` operations do delete some backing files
when explicitly asked.

Thus, outside of BTRFS, NILFS2 is the only other file-system that
provides me with built-in snapshots to be used in case of emergency.
(And I don't intend to use BTRFS for this use-case as I don't trust
its complexity for this use-case.)

To reiterate I see the following "stack" where each level provides
some assurances:
* `restic` provides logical shapshots and deduplacation (plus
checksumming and encryption) of backed-up files;
* NILFS2 provides a safety net in case of operational errors or
misbehaving software;
* mirrors (via `rsync`), especially in another location, would provide
redundancy;
* (RAID would be another option, but it doesn't provide isolation from
corruption due to file-system bugs;)



On 6/21/22 18:02, Ryusuke Konishi wrote:
> To mention just one thing, when it comes to large archive storage,
> I guess there is a perspective of resistance to the bit rot issue.
>  From this perspective, btrfs or zfs would be your choice unless
> you combine an FS with other solutions like dm-integrity.

[plus what Tommy said]

On 6/22/22 15:12, Tommy Pettersson wrote:
> But the main reason I would not recommend nilfs2 for
> long-term backup is, like Ryusuke has mentioned, that nilfs2
> does not have checksums and a corresponding scrub mechanism
> to validate that no bits on the disk have accidentally
> flipped or become unreadable.


I understand the tradeoff here, and I'm a bit disappointed that NILFS2
doesn't have data checksumming built-in.

In fact, with my current backup scheme, the above mentioned ~1.6 TiB
`restic` repository is placed on an Ext4 disk connected via an USB
enclosure, and for some reason when pushing the disk to its
(concurrency) limits, strange USB resets start to happen (that don't
happen when the disk is connected directly over SATA), and most often
when that happens bad data is returned during `read`s (as in not I/O
errors, but OK returns but with corrupted data).  When this happens
`restic` immediately reports the error and I have to disconnect /
reconnect and retry everything from the start.

Thus, getting back to the problem of checksums, they would be nice,
however I don't want to rely on them, and instead prefer the backup
solution to provide its own checksumming, which `restic` does.
Moreover (and this is something I do with all my files) I manually
keep `md5` files around that I generate once a few months, and compare
for the most important data stores;  plus I rely on Git repositories
and run `git fsck` from time-to-time.



On 6/22/22 15:12, Tommy Pettersson wrote:
> For safe long-term storage you
> will need checksums and scrubbing to detect corrupted data,
> and redundancy (raid, mirror) to correct the corruption and
> get a notice to replace the failing disk.


As noted earlier, based on the above I think I can delegate:
* checksums to either `restic` or manual `md5` files;
* (scrubbing is out of scope as I don't use RAID or similar, but given
the next point I can recover the damaged files;)
* redundancy to `rsync` copies of the `restic` repository, `git`
clones if the data permits, or plain `rsync` mirrors;
* failing disks to periodic SMART checks;



On 6/21/22 19:03, Keith wrote:
> This is why I don't 100% recommend it.  I have had no more than 4 major
> issues in 10 years where I could not purge old data. Specifically what
> that means is I had a snapshot that changed back to a checkpoint so that
> it could be purged the next time garbage collection ran.  As a result, I
> eventually had to reformat which meant giving up the current data (which
> could span several years). I sometimes use an nilfs2 fs in a loop
> mounted system on top of a large parallel / distributed filesystem and
> that combination could be the issue but it makes no sense to me why
> there is no way to get around a problem like that.  The lack of tools to
> analyze and fix that condition or to be able to efficiently copy or
> migrate data to another system continues to be an issue.  That said, I
> have NEVER lost data in snapshot and have been able to access data from
> years prior even when I can't purge.  The benefits of nilfs2 continue to
> outweigh this issue for me and if I really want all the data in a
> filesystem that can't be purged I could rebuild it manually somewhere
> else on the data lake.  That would be a p.i.t.a. but at least it is an
> option.


What you are describing might be indeed an issue if one uses NILFS2
specifically for the purpose of archival, i.e. snapshotting files.

However because you've not lost data, and you were able to go back in
time, it means that at worst I would be forced to move my backups to
another fresh drive.



On 6/22/22 15:12, Tommy Pettersson wrote:
> Another thing that could be an issue is that nilfs2 does not
> support xattr, if that is needed for the backup.

In fact I would prefer the backup solution not to rely on xattr or
other advanced features.  The simpler the better.



On 6/22/22 15:12, Tommy Pettersson wrote:
> Yet another curiosity I have had to deal with is symlink
> properties. The standard says that rwx properties of
> symlinks may be set to anything but should be ignored. All
> filesystems I have used sets them to 777, except for nilfs2,
> which honors the current umask value. Now, rsync, which is
> probably to blame here, tries to update the properties on
> symlinks, and if it reads from nilfs2, and gets something
> other than 777, it can not set this other value if the
> target is not also nilfs2, and will think it has failed. The
> only workaround I have come up with is to find all symlinks
> on nilfs2 and update their permission to 777.


I've seen this weird behaviour and doesn't bother me.

(I've also seen this behavior with AFS lately...)



Thanks to all that have responded,
Ciprian.
