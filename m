From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: hallo
Date: Fri, 12 Oct 2007 17:44:58 +0900 (JST)
Message-ID: <200710120844.l9C8iwBb028030@nuesun.nue.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Fri, 12 Oct 2007 17:45:16 +0900 (JST)
	<200710120845.l9C8iwTC064110-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from nuesun.isle.ecl.net
	163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Fri, 12 Oct 2007 17:44:58 +0900 (JST)
	<200710120844.l9C8iwBb028030-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
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

Hi, Gergely,

Sorry for slow my response.
Thank you very much for your offer.
Debugging is a major task to do.

> what is the state of the project? hould I try to put my rootfs in
> nilfs? Or any sensitive data? Is there a working garbage collector?

Unfortunately, NILFS is not able to work as Root fs.  GRUB or other
boot manager are not support NILFS disk format, Linux cannot boot from
NILFS partition.  Current version of NILFS 2.0.0 is a `testing' version yet, 
you should not store sensitive data.

Garbage collector (cleaner) is in operation on NILFS 2.0.0, please
refer a README file of NILFS distribution. 

> Can a nilfs drive be extended? (reduced?)

We have plan to get the function.  But, reducing NILFS partition is
much harder than reducing one.


Yesterday, we made a minor release of NILFSv2 testing-4, still testing
version.  And, today, we fixed a big bug that causes a calamity to
NILFS partition.  New minor release testing-5 will be made on next
Monday.  Could you test the version by some benchmark software,
such as compilebench (http://oss.oarcle.com/~mason/compilebench)
in next week?

Thanks in advance.

Amagai Yoshiji

NILFS team, NTT
http://www.nilfs.org/
