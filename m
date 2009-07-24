From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Crash...
Date: Fri, 24 Jul 2009 10:58:03 +0200
Message-ID: <20090724085803.GA23256@aardappel.13thmonkey.org>
References: <9cdbb57f0907230555k768383c2ld1690d31cc6fff83@mail.gmail.com>
	<20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Thu, Jul 23, 2009 at 11:02:47PM +0200, Andrea Gelmini wrote:
> 2009/7/23 Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>:
> > It also suggests that an inconsistent state in page cache of B-tree
> > nodes hit the function; the function found a dirty page, but the page
> > didn't have buffer heads which was supposed to be impossible for the
> > b-tree of nilfs.
>    -> mkfs.nilfs2 -b 1024 /dev/mapper/VG-NilfHome (maybe the problem
> is the 1K block size?)

1024 is lower than the page size so that might explain a lot! I think its a
missing check in the mkfs.nilfs2 to never allow lower values than the page
size for block size.... but Ryusuke can better answer that :-D

With regards,
Reinoud
