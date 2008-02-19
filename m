From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS2 git repositories
Date: Tue, 19 Feb 2008 21:54:49 +0900
Message-ID: <1203425689.3094.58.camel@localhost.localdomain>
References: <20080121.140129.01311807.ryusuke@osrg.net>
	<20080122000052.215084db@vosztok>
	<1200970920.2844.59.camel@localhost.localdomain>
	<20080205.182829.44149266.ryusuke@osrg.net>
	<20080207110930.3df85a70@vosztok>
	<1202821077.9432.99.camel@localhost.localdomain>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1202821077.9432.99.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
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
Content-Type: text/plain; charset="iso-8859-1"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi folks,

On Tue, 2008-02-12 at 21:57 +0900, Ryusuke Konishi wrote:=20
> On Thu, 2008-02-07 at 11:09 +0100, Gergely G=E1bor wrote:
> > Possibly if you set up a git/hg/other repo, life'd be more convinient.
> > they made my life simpler even in my small school projects.
>=20
> Sorry for inconvenience.
> We also have a plan to make a git (or other kind of) repository
> after it gets settled.  So please wait a little longer.

We have launched git repositories for the NILFS project.
The following two repositories are available at present.

* nilfs2 user module repository
  http://git.nilfs.org/nilfs2-module.git
* nilfs2 tool repository
  http://git.nilfs.org/nilfs2-utils.git

These repositories are browsable by gitweb,

  http://www.nilfs.org/git/

We're also preparing a kernel repository to make patches
for applying nilfs2 to the kernel sources.


You can get source code of the latest nilfs2 module as follows,

 $ git clone http://git.nilfs.org/nilfs2-module.git

Similarly, the repository for the nilfs2 userland tools=20
can be cloned as below,

 $ git clone http://git.nilfs.org/nilfs2-utils.git

These repositories are updated through git-pull command.
For more detail on git, please refer to the following sites.

* http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
* http://git.or.cz/


Since these repositories don't include any intermediate
files, you have to make some preparations before running
a configure script in nilfs2-utils:

 $ cd nilfs2-utils
 $ aclocal
 $ autoheader
 $ libtoolize -c
 $ automake -a -c
 $ autoconf


Thank you,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
