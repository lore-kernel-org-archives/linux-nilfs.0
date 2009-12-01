From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: pp (protection period) mount option
Date: Wed, 02 Dec 2009 01:02:05 +0900 (JST)
Message-ID: <20091202.010205.38314732.ryusuke@osrg.net>
References: <20091128.012303.54434171.ryusuke@osrg.net>
	<749598c60911281316i40b591b1hcb055b0867617f0e@mail.gmail.com>
	<20091202.004422.69931110.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091202.004422.69931110.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Wed, 02 Dec 2009 00:44:22 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> Hi,
> On Sat, 28 Nov 2009 22:16:31 +0100, David Smid <david-0RIiUExYzkzCfDggNXIi3w@public.gmane.org>
> wrote:
> > Thanks you for your valuable comments.
> > 
> > You are right, of course. No kernel code changes are needed.
> > Here is my take #2.
> > 
> > David
> 
> Thank you, David.  I reviewed the patch in detail, and no worrisome
> point found.
> 
> During tests, I noticed that remount doesn't work for this option:
> 
>   For instance, after doing
> 
>   # mount -t nilfs2 -o pp=3D600 /dev/sdb1 /test
> 
>   and
> 
>   # mount -t nilfs2 -o remount,pp=3D400 /dev/sdb1 /test

Whoa, looks garbled..

>   # mount -t nilfs2 -o pp=600 /dev/sdb1 /test
>   # mount -t nilfs2 -o remount,pp=400 /dev/sdb1 /test

Ryusuke
