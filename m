From: <amagai-sG5X7nlA6pw@public.gmane.org>
Subject: Re: __udivdi3
Date: Fri,  4 Jan 2008 13:32:47 +0900 (JST)
Message-ID: <20080104043247.40AB73E06C1@fs.osrg.net>
References: <20080103034154.bf6c74be.elentirmo.gilgalad@gmail.com>
	<200801032238.44785.chris@csamuel.org>
	<20080103161729.c623ad3e.elentirmo.gilgalad@gmail.com>
	<20080104014721.3D7163E06C1@fs.osrg.net>
	<20080104041630.57fd0df6.elentirmo.gilgalad@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-reply-to: <20080104041630.57fd0df6.elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (message
	from Gergely =?UTF-8?B?R8OhYm9y?= on Fri, 4 Jan 2008 04:16:30 +0100)
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Gergely, thank you for your report!

> GNU Make 3.81

The version of gnu make is same as one that I used on OpenSuse
10.3.  What's wrong???

> dat.o.lst: 974              	.globl __udivdi3
> dat.o.lst: 1245 03cb E8FCFFFF 	call __udivdi3
> dat.o.lst:__udivdi3

Could you send me ( amagai-sG5X7nlA6pw@public.gmane.org , not to ML) the whole
dat.o.lst ?  It's very useful to solve issue.

amagai-sG5X7nlA6pw@public.gmane.org
NTT Cyber Space Laboratories
NILFS team
