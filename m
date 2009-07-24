From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Crash...
Date: Fri, 24 Jul 2009 12:02:30 +0200
Message-ID: <20090724100230.GC23256@aardappel.13thmonkey.org>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
	<20090724085803.GA23256@aardappel.13thmonkey.org>
	<9cdbb57f0907240247n5ffd6f81yaee39eb386516c25@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9cdbb57f0907240247n5ffd6f81yaee39eb386516c25-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Fri, Jul 24, 2009 at 11:47:21AM +0200, Andrea Gelmini wrote:
> 2009/7/24 Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>:
> > 1024 is lower than the page size so that might explain a lot! I think its a
> > missing check in the mkfs.nilfs2 to never allow lower values than the page
> > size for block size.... but Ryusuke can better answer that :-D
> 
> I agree with you, but man page of mkfs.nilfs2 says it can be
> 1024/2048/4096/8192.
> Of course it can't be > of page size, but that's a VFS problem.

It could be an implementation limit or a bug in the sub-page handling... i
dont know linux that much :-S

With regards,
Reinoud
