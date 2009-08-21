From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Inquiry: disk format change in the future
Date: Fri, 21 Aug 2009 12:57:34 +0900 (JST)
Message-ID: <20090821.125734.96697535.ryusuke@osrg.net>
References: <20090820002457.A0C0520E21@spam-fw.osrg.net>
	<20090820.112237.04623349.ryusuke@osrg.net>
	<4A8CC93B.9090904@redhat.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A8CC93B.9090904-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hi!
On Wed, 19 Aug 2009 22:55:39 -0500, Eric Sandeen wrote:
> Ryusuke Konishi wrote:
> > (reply added to "Yann E. MORIN")
> > 
> > Hi,
> > On Wed, 19 Aug 2009 11:31:56 +0200, "Yann E. MORIN" wrote:
> >> Hello All!
> >>
> >> I've searched the archives, but could not find the answer to the
> >> following questions:
> >>
> >>  - will there be, or what is the probability of, a disk format change
> >>    in the near future (few months)?
> > 
> > We still have some possibilities for the format change at this time.
> > 
> > Basically I intend to keep the disk format, but some new features like
> > 
> > - Extended attributes, ACLs
> > - Rollback
> > - Checkpoint based remote replication
> > 
> > may require it.  So far, we haven't seen any specific requisition.
> >  
> 
> Do you expect that any of the changes may impact the ability of
> utilities such as blkid or file to recognize a nilfs filesystem?

I don't think these affect blkid or similar programs even if
additional fields may be required in the superblock.

One my concern about the automated recognition is too short magic
field of nilfs.  I think those tools will need to confirm the checksum
in addition to the magic field.

If I have a chance to reorganize the superblock, I would like to make
it longer and adjust some other fields.  But I will not do so for the
above features.

> I'd happily write patches for those utilities to add nilfs recognition
> if you think there is a stable fingerprint that can be recognized.
>
> Thanks,
> -Eric

Thank you for the proposal! I'm grateful if you could do so.  I think
the time when we drop the experimental flag from Kconfig is the time.

Thanks,
Ryusuke Konishi
