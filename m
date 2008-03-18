From: bill-ozn5a1fpZJs3uPMLIKxrzw@public.gmane.org
Subject: Re: nilfs and nfs
Date: Tue, 18 Mar 2008 13:36:58 -0400 (EDT)
Message-ID: <51831.128.221.197.20.1205861818.squirrel@webmail.cs.uml.edu>
References: <25256.128.221.197.20.1205268369.squirrel@webmail.cs.uml.edu>
	<1205481742.3674.19.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1205481742.3674.19.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
Content-Type: text/plain; charset="windows-1252"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Cc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Thank you Ryusuke, I was able to build and install your fixes and I'm now
successfully using NFS ... I appreciate your help with this very much, an=
d
I can now continue to do my NFS testing over NILFS ... best reagrds, Bill




> Hi Bill and Kallol,
>
> On Tue, 2008-03-11 at 16:46 -0400, bill-ozn5a1fpZJs3uPMLIKxrzw@public.gmane.org wrote:
>> Is there a way to export an NILFS object over NFS ?  exportfs errors
>> with
>> =93/object does not support NFS export=94 when I attempt to include an=
 entry
>> in /etc/exports for /object, which is an NILFS object =85 I=92ve tried=
 using
>> the fsid=3D option in the exports entry but this doesn=92t seem to hel=
p ...
>> any info would be appreciated ... Bill
>
> and,
>
> On Thu, 2008-03-13 at 15:52 -0400, Par_Kallol-mb1K0bWo544@public.gmane.org wrote:
>> Hi
>>
>> I am currrently evaluating NILFS.
>>
>> I am having trouble (remotely) mounting a NILFS volume from an NFS
>> client. I get a message from the server as "permission denied". I have
>> made my mount "world rw" accessible.
>>
>> Please let me know if you can help.
>
> Thanks you for reporting the problem!
>
> I've tracked the problem and implemented a few features needed to suppo=
rt
> nfs (exportfs), and pushed the patch to my git tree a little while ago.
>
> Could you try the latest version on the git tree ?
> It is available as follows,
>
>  $ git clone http://git.nilfs.org/nilfs2-module.git
>  $ cd nilfs2-module
>  $ make
>  $ sudo make install
>
> It may require git-core (or git) package if not installed.
>
> Best regards,
> --
> Ryusuke Konishi
> NILFS team NTT
> http://www.nilfs.org/
>
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>



-----------------------------------------
This email was sent using SquirrelMail.
   "Webmail for nuts!"
http://squirrelmail.org/
