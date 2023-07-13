From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: {WHAT?} read checksum verification
Date: Thu, 13 Jul 2023 06:23:21 +0200
Message-ID: <b99d2029-9b96-a016-875e-09b208c0ab9c@prnet.org>
References: <174f995c-e794-74c4-24d6-52451f3f3f28@prnet.org>
 <25775.10549.41499.886957@petal.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <25775.10549.41499.886957-Lv72GqZ7opur1GY8YIlKTvXRex20P6io@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org>, list Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 7/13/23 00:29, Peter Grandi wrote:
>> I used NILFS over ISCSI. I had random block corruption during
>> one week, silently destroying data until NILFS finally
>> crashed. First of all, I thought about a NILFS bug, so I
>> created a BTRFS volume
> I use both for main filesystem and backup for "diversity", and I
> value NILFS2 because it is very robust (I don't really use
> either filesystems snapshotting features).
So do I, therefor I said it was not NILFS fault.
>> and restored the backup from one week earlier to it. After
>> minutes, the BTRFS volume gave checksum errors, so the
>> culrprit was found, the ISCSI server.
> There used to be a good argument that checksumming (or
> compressing) data should be end-to-end and checksumming (or
> compressing) in the filesystem is a bit too much, but when LOGFS
> and NILFS/nILFS2 were designed I guess CPUs were too slow to
> checksum everything. Even excellent recent filesystems like F2FS
> don't do data integrity checking for various reasons though.
>
> In theory your iSCSI or its host-adapter should have told you
> about errors... Many can enable after-write verification (even
> if its quite expensive). Alternatively some people run regularly
> silent-corruption detecting daemons if their hardware does not
> report corruption or it escapes the relevant checks for various
> reasons:

The host adapter can return errors if underlying the disk itself returns 
them. If bits randomly flip on disk after being written, the host 
adapter can't know (at least not in non raid scenarios).

> https://indico.desy.de/event/257/contributions/58082/attachments/37574/46878/kelemen-2007-HEPiX-Silent_Corruptions.pdf
> https://storagemojo.com/2007/09/19/cerns-data-corruption-research/
>
>> [...] NILFS creates checksums on block writes. It would really
>> be a good addition to verify these checksums on read [...]
> It would be interesting to have data integrity checking or
> compression in NILFS2, and log-structured filesystem makes that
> easier (Btrfs code is rather complex instead), but modifying
> mature and stable filesystems is a risky thing...
>
> My understanding is that these checksums are not quite suitable
> for data integrity checks but are designed for log-sequence
> recovery, a bit like journal checksums for journal-based
> filesystems.
>
> https://www.spinics.net/lists/linux-nilfs/msg01063.html
> "nilfs2 store checksums for all data. However, at least the
> current implementation does not verify it when reading.
> Actually, the main purpose of the checksums is recovery after
> unexpected reboot; it does not suit for per-file data
> verification because the checksums are given per ``log''."

It think exactly this would be interesting, if checksum per log already 
exist, it would be good to verify these on read. As already said, I am 
not expecting to know on which file corruption occurred, but it would be 
nice to know that something nasty is going on.

