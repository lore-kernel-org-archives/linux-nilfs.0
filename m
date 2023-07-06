From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 00/89] fs: new accessors for inode->i_ctime
Date: Thu, 06 Jul 2023 10:16:19 -0500
Message-ID: <87ilaxgjek.fsf@email.froward.int.ebiederm.org>
References: <20230705185812.579118-1-jlayton@kernel.org>
 <a4e6cfec345487fc9ac8ab814a817c79a61b123a.camel@kernel.org>
Mime-Version: 1.0
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
In-Reply-To: <a4e6cfec345487fc9ac8ab814a817c79a61b123a.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Jeff
 Layton's message of "Wed, 05 Jul 2023 17:57:46 -0400")
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, al-V9/YLgxv/GvR7s880joybQ@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org, pc-mxznQ8SDR6Dby3iVrkZq2A@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, jeffxu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, john-HPTTJ/6qucUJ3nxcUk3PyQ@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, christophe.leroy-2tlSp11Fh4xulxpn9UvDqw@public.gmane.org, code-TpHmOWrMQl1BDgjK7y7TUQ@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, borntraeger-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, devel-urhm25FSIHzptaDgeN77Px2eb7JE58TQ@public.gmane.org, mirimmad17-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sprasad-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ericvh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org, anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wsa+renesas-jBu1N2QxHDJrcw3mvpCnnVaTQe2KTcn/@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stephen.smalley.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lsah

Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> On Wed, 2023-07-05 at 14:58 -0400, Jeff Layton wrote:
>> v2:
>> - prepend patches to add missing ctime updates
>> - add simple_rename_timestamp helper function
>> - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_*
>> - drop individual inode_ctime_set_{sec,nsec} helpers
>> 
>> I've been working on a patchset to change how the inode->i_ctime is
>> accessed in order to give us conditional, high-res timestamps for the
>> ctime and mtime. struct timespec64 has unused bits in it that we can use
>> to implement this. In order to do that however, we need to wrap all
>> accesses of inode->i_ctime to ensure that bits used as flags are
>> appropriately handled.
>> 
>> The patchset starts with reposts of some missing ctime updates that I
>> spotted in the tree. It then adds a new helper function for updating the
>> timestamp after a successful rename, and new ctime accessor
>> infrastructure.
>> 
>> The bulk of the patchset is individual conversions of different
>> subsysteme to use the new infrastructure. Finally, the patchset renames
>> the i_ctime field to __i_ctime to help ensure that I didn't miss
>> anything.
>> 
>> This should apply cleanly to linux-next as of this morning.
>> 
>> Most of this conversion was done via 5 different coccinelle scripts, run
>> in succession, with a large swath of by-hand conversions to clean up the
>> remainder.
>> 
>
> A couple of other things I should note:
>
> If you sent me an Acked-by or Reviewed-by in the previous set, then I
> tried to keep it on the patch here, since the respun patches are mostly
> just renaming stuff from v1. Let me know if I've missed any.
>
> I've also pushed the pile to my tree as this tag:
>
>     https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/tag/?h=ctime.20230705
>
> In case that's easier to work with.

Are there any preliminary patches showing what you want your introduced
accessors to turn into?  It is hard to judge the sanity of the
introduction of wrappers without seeing what the wrappers are ultimately
going to do.

Eric

