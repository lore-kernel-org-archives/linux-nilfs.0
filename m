From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: [NILFS users] Ready for production?
Date: Fri, 14 Sep 2007 18:11:04 +0900 (JST)
Message-ID: <200709140911.l8E9B4gs069204@nuesun.nue.org>
References: <C2BCD995-1AB0-4A23-983A-0B35483702FB@lsi.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Fri, 14 Sep 2007 18:11:23 +0900 (JST)
	<200709140911.l8E9B4sx056451-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from nuesun.isle.ecl.net
	163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Fri, 14 Sep 2007 18:11:04 +0900 (JST)
	<200709140911.l8E9B4gs069204-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <C2BCD995-1AB0-4A23-983A-0B35483702FB-M7mHMAq9Yzo@public.gmane.org>
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

> How stable is NILFS? Is it ready for production? Does it work fine  
> with rsync?

Unfortunately not.  Garbage collector may break some NILFS 
internal system files.  We do debug the problem, but not be
solved yet.

> I've got another question. I noticed on the TODO list that ACL's  
> aren't currently supported. Is that still true and if so, any guess  

Yes, ACL's, an extended attribute, quota ... are not supported yet.

> as to when ACL's will be supported? Or does the development team  
> expect ACL support to be added by the community?

Any contribution are welcome! 

We have a plan to implement a B-tree base directory management, 
the B-tree routines may be usable for xattr and ACL implementation,
but we are not working for support ACL now, supporting in another
method is acceptable.

Thanks.
-- 
NILFS Team, NTT Labs.
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
