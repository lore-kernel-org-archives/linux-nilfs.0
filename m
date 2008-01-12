From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: named snapshots
Date: Sat, 12 Jan 2008 16:43:33 +0900 (JST)
Message-ID: <200801120743.m0C7hX4Y060844@nuesun.nue.org>
References: <20080104172104.d4d00c96.elentirmo.gilgalad@gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Sat, 12 Jan 2008 16:43:51 +0900 (JST)
	<200801120743.m0C7hXnc036752-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from ns.nue.org. 163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Sat, 12 Jan 2008 16:43:33 +0900 (JST)
	<200801120743.m0C7hX4Y060844-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <20080104172104.d4d00c96.elentirmo.gilgalad-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
> Now that nilfs2 is getting alive on my box, I started to wonder is there
> will be support for named snapshots?

Our TODO List (http://www.nilfs.org/en/current_status.html) includes
"Snapshot management mechanism", for example, adding name (or symbolic
tag) to snapshot, making multiple checkpoints to snapshots
automatically on some conditions, etc.

However, the plans are not started to design yet.  If you have
some ideas, please post this users ML.

By the way, all checkpoints has a data space which is freely able to
use by user, called ``sketch''.  The special file, named .sketch, is
exists on mount point of nilfs2.  You can write data to .sketch or
read the data from .sketch.  When disk write (segment construction) is
performed by sync or fsync, the data are saved with the checkpoint.
The I/O to .sketch does not kick any segment constructions.

On current version of NILFS2, .sketch on past checkpoint is appeared
after, making the checkpoint to snapshot, then mount the snapshot on
some mount point directory.

It is not convenient to use the sketch feature, we know.

Some tools are required which read any .sketch without mount the
nilfs2 partition.  We should add it to our TODO list!

Thank you.

Amagai Yoshiji

NILFS team, NTT
http://www.nilfs.org/
