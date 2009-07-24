From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Crash...
Date: Fri, 24 Jul 2009 19:47:59 +0900 (JST)
Message-ID: <20090724.194759.112623624.ryusuke@osrg.net>
References: <9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
	<20090724085803.GA23256@aardappel.13thmonkey.org>
	<9cdbb57f0907240247n5ffd6f81yaee39eb386516c25@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, andrea.gelmini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, 24 Jul 2009 11:47:21 +0200, Andrea Gelmini wrote:
> 2009/7/24 Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>:
> > 1024 is lower than the page size so that might explain a lot! I think its a
> > missing check in the mkfs.nilfs2 to never allow lower values than the page
> > size for block size.... but Ryusuke can better answer that :-D
> 
> I agree with you, but man page of mkfs.nilfs2 says it can be
> 1024/2048/4096/8192.
> Of course it can't be > of page size, but that's a VFS problem.

Exactly.
 
> Ciao,
> Andrea

Cheers,
Ryusuke Konishi
