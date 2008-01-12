From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: Question on porting nilfs back to linux 2.4.3
Date: Sat, 12 Jan 2008 16:57:16 +0900 (JST)
Message-ID: <200801120757.m0C7vGkX061277@nuesun.nue.org>
References: <b008462b0801091113w620d9321p21de1d76f8dd3e8c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Sat, 12 Jan 2008 16:57:34 +0900 (JST)
	<200801120757.m0C7vGgo036795-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from ns.nue.org. 163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Sat, 12 Jan 2008 16:57:16 +0900 (JST)
	<200801120757.m0C7vGkX061277-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <b008462b0801091113w620d9321p21de1d76f8dd3e8c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Content-Type: TEXT/PLAIN; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
thank you for your interest on NILFS, here is a not
good news.

> on linux kernel 2.4.3), I'm thinking of porting nilfs for 2.4.3

NILFS is depended heavily on Linux kernel 2.6, especially page cache
operations, buffer head operations, memory shrinker, block I/O
mechanism and so on.  It should be a very hard work to port nilfs to
2.4.3.

Amagai Yoshiji

NILFS team, NTT
http://www.nilfs.org/
