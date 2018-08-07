#include<iostream>
#include<string>
#include<fstream>
#include<map>
#include<map>
#include<vector>
#include<cstdlib>
#include<algorithm>

using namespace std;

//function to write each row. i.e. founders with SVs for a given gene
void findStrain(vector<string>& tempList,vector<string> & strainList,string & geneName,map<string,string> & lenList);
vector<string> splitField(string & str, char c);
//vector<string> getIds(vector<string>& tempList); 
void getIds(vector<string>& tempList,string & strain);//prints ids corresponding to a gene and strain str

int main(int argc, char * argv[])
{
	if(argc<4)
	{
		cerr<<"Usage :\t"<<argv[0]<<" strain_list.txt gene_list.txt formatted_table.txt\n";
		exit(EXIT_FAILURE);
	}

	//list of variables
	vector<string> strainList,geneList,varList;
	map<string,vector<string> > tempList;  
	map<string,string> lenList;//a map of gene lengths. indices are gene names
	string str;
	vector<string> vs;
	ifstream fstrain,fgene,ftable;
	fstrain.open(argv[1]);
	cout<<"Gene\tLength\t";
	while(getline(fstrain,str))
	{
		strainList.push_back(str);
		cout<<"\t"<<str;
	}
	cout<<endl;
	fstrain.close();
	fgene.open(argv[2]);
	while(getline(fgene,str))
	{
		vs = splitField(str,'\t');
		geneList.push_back(vs[0]);
		lenList[vs[0]] = vs[1];
		//cout<<vs[0]<<"\t"<<vs[1]<<endl;
	}
	fgene.close();
	ftable.open(argv[3]);
	while(getline(ftable,str))
	{
		varList.push_back(str);
	}
	ftable.close();		
	
	for(unsigned int i=0;i<geneList.size();i++)
	{
		for(unsigned int j=0; j<varList.size();j++)
		{
			str = varList[j];
			vs = splitField(str,'\t');
			//cout<<geneList[i]<<"\t"<<vs[5]<<endl;
			if((varList[j].find(geneList[i]) != string::npos) && (vs[6] == geneList[i])) 	
			{
				tempList[geneList[i]].push_back(varList[j]);//get all the SVs corresponding to a gene
				//cout<<geneList[i]<<"\t"<<vs[5]<<endl;
			}
		}
		findStrain(tempList[geneList[i]],strainList,geneList[i],lenList);
		tempList.clear();
	}	
			
	return 0;
}
//////////////////////////////////function to find the strains for a gene//////////////////////
void findStrain(vector<string>& tempList,vector<string> & strainList,string & geneName,map<string,string> & lenList)
{
	string varLine;
	string str;
	map<string,bool> strainGenotype;
	vector<string> vs;
	for(unsigned int i =0; i<tempList.size();i++)
	{
		for(unsigned int j = 0;j<strainList.size();j++)
		{
			vs = splitField(tempList[i],'\t');
			if(vs[3].find(strainList[j]) != string::npos)//look for the strain name in the strain field
			{
				strainGenotype[strainList[j]] = 1;
				//cout<<geneName<<"\t"<<1<<"\t"<<strainGenotype[strainList[j]]<<endl;
			} 
			else
			{
				if(strainGenotype[strainList[j]] != 1)
				{
					strainGenotype[strainList[j]] = 0;
					//cout<<geneName<<"\t"<<0<<"\t"<<strainGenotype[strainList[j]]<<endl;
				}
			}	
		}
	}
	cout<<geneName<<'\t'<<lenList[geneName]<<'\t';//print the gene name. this is column 1
	for(unsigned int i=0;i<strainList.size();i++)
	{
		if(strainGenotype[strainList[i]] == true)
		{
			//cout<<"\t1";
			cout<<'\t';
			str = strainList[i];
			getIds(tempList,str);
		}
		else
		{
			cout<<"\tNA";		
		}
	}
	cout<<endl;
}
//////////////////////////////////////////////////////////////////////
vector<string> splitField(string & str, char c)
{
	size_t pos =1, pos1 =0;
	vector<string> vs;
	string tempstr;
	while(pos1 <str.size())
	{
		pos1 = str.find(c,pos);
		if(pos1 < str.size())
		{
			tempstr = str.substr(pos-1,pos1-pos+1);
			if(tempstr[0] == c)
			{
				tempstr = tempstr.substr(1); //remove the preceding delimiter
			}
			pos = pos1+1;
			vs.push_back(tempstr);
			//cout<<tempstr<<endl;	
		}
		if((pos1 == string::npos) && (pos ==1))//c does not exist in the string, so pos is not changed
		{
			pos = 0;
		}
	}
	tempstr = str.substr(pos);
	//cout<<tempstr<<endl;
	vs.push_back(tempstr);
	return vs;
}

////////////////////////////////getid function////////////////////////////
//vector<string> getIds(vector<string>& tempList)
void getIds(vector<string>& tempList,string & strain)
{
	map<string,vector<string> > strainToid;
	map<string,string> strainToidCNV;
	vector<string> ids,tempids,strainids;
	string str,tempid,strainid;

	for(unsigned int i=0;i<tempList.size();i++)
	{
		str = tempList[i];
		if(str.find("CNV") != string::npos)//if the SV is a CNV
		{
			tempids = splitField(str,'\t');//split the fields of the line
			tempid = tempids[4];
			strainid = tempids[3];
			//cout<<tempids[3]<<'\t'<<tempids[4]<<endl;
			tempids = splitField(tempid,'|');//split the id field
			strainids = splitField(strainid,'|');//split the strain field
			for(unsigned int j=0;j<strainids.size();j++)
			{
				//cout<<"CNV\t"<<tempids[0]<<'\t'<<strainids[j]<<endl;
				strainToidCNV[strainids[j]]= tempids[0];
	
			}
			 	
		}
		if(str.find("NO") != string::npos)// if not CNV
		{
			tempids = splitField(str,'\t');//split the fields of the line
			tempid = tempids[4];
			strainid = tempids[3];
			tempids = splitField(tempid,'|');//split the id field
			strainids = splitField(strainid,'|');//split the strain field
			//for(unsigned int j=0;j<tempids.size();j++)
			for(unsigned int j=0;j<strainids.size();j++)
			{
				//cout<<"no-CNV\t"<<tempids[0]<<'\t'<<strainids[j]<<endl;
				//ids.push_back(tempids[j]);//add it to the ids container
				strainToid[strainids[j]].push_back(tempids[0]);
			}
		}	
	}
		for(map<string,string>::iterator it = strainToidCNV.begin();it != strainToidCNV.end();it++)
		{
			if(it->second != "")
			{
				//cout<<"MAP\t"<<it->first<<'\t'<<it->second<<endl;
				if(find(strainToid[it->first].begin(),strainToid[it->first].end(),it->second) == strainToid[it->first].end()) //if this id isn't already there
				{
					strainToid[it->first].push_back(it->second);
				}
			}
		}
		for(map<string,vector<string> >::iterator it = strainToid.begin();it != strainToid.end();it++)
		{
			str = it->first;//get the name of the string
			if((it->second.size()>0) && (str.find(strain) != string::npos))//if the strain is there
			{
				for(unsigned int i=0;i<strainToid[it->first].size();i++)
				{
					if(i == 0)
					{
						cout<<it->second[i];
					}
					else
					{
						cout<<';'<<it->second[i];
					}
				}
			
			}
		}
}
