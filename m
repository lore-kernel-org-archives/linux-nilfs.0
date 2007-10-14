From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: memory space
Date: Sun, 14 Oct 2007 16:38:29 +0900 (JST)
Message-ID: <200710140738.l9E7cTSZ099338@nuesun.nue.org>
References: <HNEOIAEJHENCDLHKJGHBMEHNDAAA.lucky-joe@gmx.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Sun, 14 Oct 2007 16:38:47 +0900 (JST)
	<200710140738.l9E7cT6Q080282-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from nuesun.isle.ecl.net
	163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Sun, 14 Oct 2007 16:38:29 +0900 (JST)
	<200710140738.l9E7cTSZ099338-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <HNEOIAEJHENCDLHKJGHBMEHNDAAA.lucky-joe-Mmb7MZpHnFY@public.gmane.org>
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

Hi Joe, 

> I am planning to use nilfs with a memory block device under user-mode linux
> with a 2MB static-ramdisc. So what are the memory-sized I minimal need to
> integrate it in my linux and how much space is neede for the jornalling ?

A `2MByte' disk space is too small for NILFS partition. 
NILFS does not additional space for jarnaling, but some internal meta data
files are needed.  Can you get any more space for ramdisc??

-- 
Amagai Yoshiji
NILFS Team, NTT Labs.
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
