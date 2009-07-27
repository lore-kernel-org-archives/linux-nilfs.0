From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Crash...
Date: Mon, 27 Jul 2009 16:45:18 +0900 (JST)
Message-ID: <20090727.164518.74117702.ryusuke@osrg.net>
References: <20090724085803.GA23256@aardappel.13thmonkey.org>
	<20090724.194617.88653682.ryusuke@osrg.net>
	<20090724111333.GE23256@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090724111333.GE23256-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org

Hi,
On Fri, 24 Jul 2009 13:13:33 +0200, Reinoud Zandijk wrote:
> Hi Ryusuke,
> 
> On Fri, Jul 24, 2009 at 07:46:17PM +0900, Ryusuke Konishi wrote:
> > We have implemented nilfs to allow smaller block sizes in order to
> > support some devices such like DVD/CD-ROM or flash based ones.
> 
> sounds fine :) i had some ideas about using NiLFS on CD-R/DVD*R and some ideas
> about refining NiLFS on flash based media.
> 
> For CD-R/DVD*R the last block written (or written several times) can be the
> superblock so sequential media will work just fine. No use for a garbage
> collector there ;)

I didn't mean the on-the-fly burning, but it sounds interesting.

NILFS already has the secondary superblock in tail of the device, so
it seems achievable by adjusting writeback of two superblocks.

It sounds like UDF except that NILFS allows snapshot access
though even UDF seems to be capable of restoring past data in theory.
(I dunno if it can in reality)
 
> For flash media, the entire first segment/erase block can be used to store the
> superblock in; filling it up sequentially and when full, trigger the erase
> block wiping :)
> 
> Idea?
>
> With regards,
> Reinoud

Sounds nice.

I have a pending patch in the experimental tree which allows nilfs to
issue erase commands to the segment GC reclaimed.  But, I felt it
lacks something needed by flash devices.

If we add a ssd mount option to nilfs, I think this sort of ingenuity
to increase the lifespan of the device should be taken in.

Cheers,
Ryusuke Konishi
