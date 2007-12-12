From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: A question about segment sizes and alignment
Date: Wed, 12 Dec 2007 17:30:46 +0900 (JST)
Message-ID: <200712120830.lBC8Uk9s032124@nuesun.nue.org>
References: <196f72b10712111059m2e813aa4ga02ce5ccef4ae1ba@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Wed, 12 Dec 2007 17:31:04 +0900 (JST)
	<200712120831.lBC8UkA4042684-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from nuesun.isle.ecl.net
	163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Wed, 12 Dec 2007 17:30:46 +0900 (JST)
	<200712120830.lBC8Uk9s032124-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <196f72b10712111059m2e813aa4ga02ce5ccef4ae1ba-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

> What is the segment size that NILFS uses?
> Is it possible to tune the segment size, perhaps by changing constants

You can specify the segmnent size by mkfs.nilfs2 -c and -B options.
mkfs.nilfs2 [-b block-size] [-B blocks-per-segment] ... 

Default are:  block-size == 4096 (byte), blocks-per-segment == 2048,
so, default segment size is 8Mbyte.
(They are coded in util/sbin/mkfs/mkfs.h)

> Are the segments aligned in the address space of the block device?
> That is, if each segment is 1MB, say, do the first one start in

Yes. So, user usable data blocks of the first segment may be some blocks
shorter for boot block and super blocks.

Amagai Yoshiji

NILFS team, NTT
http://www.nilfs.org/
